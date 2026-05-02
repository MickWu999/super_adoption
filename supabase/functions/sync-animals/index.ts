import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const MOA_API_URL = "https://data.moa.gov.tw/Service/OpenData/TransService.aspx";
const MOA_UNIT_ID = "QcbUEzN6E6DL";
const MAX_TOP = 1000;
const MAX_AUTO_PAGES = 500;

type Json = Record<string, unknown>;

const jsonHeaders = { "Content-Type": "application/json; charset=utf-8" };

function toTaiwanIsoString(date = new Date()): string {
  const taiwanTime = new Date(date.getTime() + 8 * 60 * 60 * 1000);
  return taiwanTime.toISOString().replace("Z", "+08:00");
}

function toText(value: unknown): string {
  if (value == null) return "";
  return String(value).trim();
}

function toInt(value: unknown): number | null {
  if (value == null || value === "") return null;
  const n = Number(value);
  return Number.isFinite(n) ? Math.trunc(n) : null;
}

function clampInt(value: unknown, fallback: number, min: number, max: number): number {
  const n = Number(value);
  if (!Number.isFinite(n)) return fallback;
  return Math.min(max, Math.max(min, Math.trunc(n)));
}

function pickImageUrl(row: Json): string {
  const albumFile = toText(row["album_file"]);
  if (!albumFile) return "";
  // Some rows may contain multiple URLs separated by semicolons.
  return albumFile.split(";").map((v) => v.trim()).find(Boolean) ?? "";
}

function mapAnimalRow(row: Json, syncAtIso: string, syncRunId: string) {
  const subId = toText(row["animal_subid"]);
  if (!subId) return null;

  return {
    sub_id: subId,
    latest_animal_id: toInt(row["animal_id"]),
    animal_area_pkid: toInt(row["animal_area_pkid"]),
    animal_shelter_pkid: toInt(row["animal_shelter_pkid"]),
    name: toText(row["animal_name"]),
    kind: toText(row["animal_kind"]),
    variety: toText(row["animal_Variety"]).replace(/\s+/g, ''),
    sex: toText(row["animal_sex"]),
    body_type: toText(row["animal_bodytype"]),
    age: toText(row["animal_age"]),
    color: toText(row["animal_colour"]),
    animal_place: toText(row["animal_place"]),
    found_place: toText(row["animal_foundplace"]),
    title: toText(row["animal_title"]),
    status: toText(row["animal_status"]),
    remark: toText(row["animal_remark"]),
    caption: toText(row["animal_caption"]),
    sterilization: toText(row["animal_sterilization"]),
    bacterin: toText(row["animal_bacterin"]),
    open_date: toText(row["animal_opendate"]),
    closed_date: toText(row["animal_closeddate"]),
    animal_update: toText(row["animal_update"]),
    animal_create_time: toText(row["animal_createtime"]),
    cdate: toText(row["cDate"]),
    album_update: toText(row["album_update"]),
    shelter_name: toText(row["shelter_name"]),
    shelter_address: toText(row["shelter_address"]),
    shelter_tel: toText(row["shelter_tel"]),
    image_url: pickImageUrl(row),
    raw_data: row,
    synced_at: syncAtIso,
    last_seen_at: syncAtIso,
    last_seen_run_id: syncRunId,
    missing_sync_count: 0,
    is_in_shelter: true,
    left_shelter_at: null,
  };
}

function dedupeBySubId(rows: Array<NonNullable<ReturnType<typeof mapAnimalRow>>>) {
  // MOA payload may contain duplicate animal_subid in a single page.
  // Keep the last row (usually the newest in API order) for each sub_id.
  const map = new Map<string, NonNullable<ReturnType<typeof mapAnimalRow>>>();
  for (const row of rows) {
    map.set(row.sub_id, row);
  }
  return Array.from(map.values());
}

async function fetchMoaBatch(top: number, skip: number): Promise<Json[]> {
  const url = new URL(MOA_API_URL);
  url.searchParams.set("UnitId", MOA_UNIT_ID);
  url.searchParams.set("$top", String(top));
  url.searchParams.set("$skip", String(skip));

  const response = await fetch(url.toString(), {
    headers: { "Accept": "application/json" },
  });

  if (!response.ok) {
    throw new Error(`MOA API failed: ${response.status} ${response.statusText}`);
  }

  const data = await response.json();
  if (!Array.isArray(data)) {
    throw new Error("MOA API response is not an array.");
  }

  return data as Json[];
}

function buildResponse(status: number, body: Record<string, unknown>) {
  return new Response(JSON.stringify(body), { status, headers: jsonHeaders });
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return buildResponse(405, { ok: false, error: "Method not allowed. Use POST." });
  }

  try {
    const payload = await req.json().catch(() => ({}));
    const top = clampInt(payload?.top, MAX_TOP, 1, MAX_TOP);
    const maxPages = payload?.maxPages == null
      ? MAX_AUTO_PAGES
      : clampInt(payload.maxPages, 1, 1, MAX_AUTO_PAGES);
    const startSkip = clampInt(payload?.startSkip, 0, 0, 5000000);
    const dryRun = Boolean(payload?.dryRun ?? false);
    const markLeaveThreshold = clampInt(payload?.markLeaveThreshold, 2, 1, 10);
    const syncRunId = crypto.randomUUID();
    const syncAtIso = toTaiwanIsoString();

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in function environment.");
    }

    const supabase = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    // Ensure migration is applied and required tables exist.
    const { error: tableCheckError } = await supabase
      .from("animals")
      .select("sub_id,last_seen_run_id,missing_sync_count,is_in_shelter", { head: true, count: "exact" })
      .limit(1);

    if (tableCheckError) {
      throw new Error(`Table check failed (public.animals): ${tableCheckError.message}`);
    }

    let fetchedCount = 0;
    let mappedCount = 0;
    let upsertedCount = 0;
    let pageCount = 0;
    let markedMissingCount = 0;
    let markedLeaveCount = 0;

    for (let page = 0; page < maxPages; page += 1) {
      const skip = startSkip + page * top;
      const rows = await fetchMoaBatch(top, skip);
      if (rows.length === 0) break;

      fetchedCount += rows.length;
      pageCount += 1;

      const mapped = rows
        .map((row) => mapAnimalRow(row, syncAtIso, syncRunId))
        .filter((row): row is NonNullable<ReturnType<typeof mapAnimalRow>> => row !== null);

      const deduped = dedupeBySubId(mapped);

      mappedCount += mapped.length;

      if (!dryRun && deduped.length > 0) {
        const { error: upsertError } = await supabase
          .from("animals")
          .upsert(deduped, { onConflict: "sub_id", ignoreDuplicates: false });

        if (upsertError) {
          throw new Error(`Upsert failed at page=${page + 1}, skip=${skip}: ${upsertError.message}`);
        }
      }

      upsertedCount += deduped.length;

      if (rows.length < top) {
        break;
      }
    }

    if (!dryRun) {
      const { data: absenceResult, error: absenceError } = await supabase.rpc(
        "apply_animals_absence",
        {
          p_sync_run_id: syncRunId,
          p_threshold: markLeaveThreshold,
          p_mark_at: syncAtIso,
        },
      );

      if (absenceError) {
        throw new Error(`Failed to apply animals absence rules: ${absenceError.message}`);
      }

      const resultRow = Array.isArray(absenceResult) ? absenceResult[0] : null;
      markedMissingCount = Number(resultRow?.marked_missing_count ?? 0);
      markedLeaveCount = Number(resultRow?.marked_leave_count ?? 0);
    }

    if (!dryRun) {
      const checkpoint = {
        checkpoint_key: "animals_last_synced_at",
        checkpoint_value: syncAtIso,
        description: "上次成功同步農業部動物資料時間",
        meta: {
          source: "moa_api",
          syncRunId,
          top,
          maxPages,
          startSkip,
          markLeaveThreshold,
          fetchedCount,
          upsertedCount,
          pageCount,
          markedMissingCount,
          markedLeaveCount,
        },
      };

      const { error: checkpointError } = await supabase
        .from("sync_checkpoints")
        .upsert(checkpoint, { onConflict: "checkpoint_key" });

      if (checkpointError) {
        throw new Error(`Failed to write sync checkpoint: ${checkpointError.message}`);
      }
    }

    return buildResponse(200, {
      ok: true,
      dryRun,
      top,
      maxPages,
      startSkip,
      markLeaveThreshold,
      syncRunId,
      pageCount,
      fetchedCount,
      mappedCount,
      upsertedCount,
      markedMissingCount,
      markedLeaveCount,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return buildResponse(500, { ok: false, error: message });
  }
});
