create extension if not exists pg_cron;
create extension if not exists pg_net;

-- Keep a friendly record in application table.
insert into public.job_schedules (
  job_key,
  name,
  description,
  schedule_type,
  cron_expression,
  is_enabled,
  meta
)
values (
  'sync_animals_daily',
  '每日同步動物資料',
  '每日自動呼叫 Edge Function：sync-animals',
  'cron',
  '0 18 * * *',
  true,
  jsonb_build_object(
    'timezone', 'Asia/Taipei',
    'run_at_utc', '18:00',
    'top', 1000,
    'mode', 'auto-until-end'
  )
)
on conflict (job_key) do update set
  name = excluded.name,
  description = excluded.description,
  schedule_type = excluded.schedule_type,
  cron_expression = excluded.cron_expression,
  is_enabled = excluded.is_enabled,
  meta = excluded.meta,
  updated_at = now();

-- IMPORTANT:
-- 1) In Supabase Dashboard -> Vault, create two secrets:
--    - project_url: https://<project-ref>.supabase.co
--    - anon_key: your project anon key
-- 2) This cron sends a POST to Edge Function daily at 02:00 Asia/Taipei (18:00 UTC).

select cron.unschedule(jobid)
from cron.job
where jobname = 'sync-animals-daily';

select cron.schedule(
  'sync-animals-daily',
  '0 18 * * *',
  $$
  select
    net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/sync-animals',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'anon_key')
      ),
      body := jsonb_build_object(
        'top', 1000,
        'startSkip', 0,
        'dryRun', false
      )
    );
  $$
);
