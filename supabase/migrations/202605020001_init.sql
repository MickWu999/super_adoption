create extension if not exists "pgcrypto";

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text default '',
  avatar_url text default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.animals (
  -- 穩定唯一鍵（農業部收容編號）
  sub_id text primary key,

  -- API 流水號（可能更新遞增）
  latest_animal_id bigint,

  animal_area_pkid int,
  animal_shelter_pkid int,

  name text default '',
  kind text default '',
  variety text default '',
  sex text default '',
  body_type text default '',
  age text default '',
  color text default '',

  animal_place text default '',
  found_place text default '',
  title text default '',
  status text default '',
  remark text default '',
  caption text default '',

  sterilization text default '',
  bacterin text default '',

  open_date text default '',
  closed_date text default '',
  animal_update text default '',
  animal_create_time text default '',
  cdate text default '',
  album_update text default '',

  shelter_name text default '',
  shelter_address text default '',
  shelter_tel text default '',

  image_url text default '',

  raw_data jsonb default '{}'::jsonb,
  synced_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.animal_favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  animal_sub_id text not null references public.animals(sub_id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, animal_sub_id)
);

create table public.job_schedules (
  id uuid primary key default gen_random_uuid(),
  job_key text not null unique,
  name text not null,
  description text default '',
  is_enabled boolean not null default true,
  schedule_type text not null default 'cron',
  cron_expression text default '',
  interval_minutes int,
  last_run_at timestamptz,
  next_run_at timestamptz,
  last_status text default '',
  last_error text default '',
  run_count bigint not null default 0,
  meta jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint chk_job_schedule_type
    check (schedule_type in ('cron', 'interval', 'manual'))
);

create table public.job_runs (
  id uuid primary key default gen_random_uuid(),
  job_schedule_id uuid not null references public.job_schedules(id) on delete cascade,
  status text not null default 'running',
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  processed_count int not null default 0,
  success_count int not null default 0,
  failed_count int not null default 0,
  message text default '',
  error text default '',
  meta jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint chk_job_run_status
    check (status in ('running', 'success', 'failed', 'cancelled'))
);

create table public.sync_checkpoints (
  checkpoint_key text primary key,
  checkpoint_value text not null default '',
  description text default '',
  meta jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create index idx_animals_latest_animal_id on public.animals(latest_animal_id);
create index idx_animals_kind on public.animals(kind);
create index idx_animals_status on public.animals(status);
create index idx_animals_area on public.animals(animal_area_pkid);
create index idx_animals_shelter on public.animals(animal_shelter_pkid);
create index idx_animal_favorites_user_id on public.animal_favorites(user_id);
create index idx_animal_favorites_animal_sub_id on public.animal_favorites(animal_sub_id);
create index idx_job_runs_job_schedule_id on public.job_runs(job_schedule_id);
create index idx_job_runs_status on public.job_runs(status);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

create trigger trg_animals_set_updated_at
before update on public.animals
for each row
execute function public.set_updated_at();

create trigger trg_job_schedules_set_updated_at
before update on public.job_schedules
for each row
execute function public.set_updated_at();

create trigger trg_sync_checkpoints_set_updated_at
before update on public.sync_checkpoints
for each row
execute function public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.animals enable row level security;
alter table public.animal_favorites enable row level security;

alter table public.job_schedules enable row level security;
alter table public.job_runs enable row level security;
alter table public.sync_checkpoints enable row level security;

create policy "Anyone can read animals"
on public.animals
for select
to public
using (true);

create policy "Users can insert own profile"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

create policy "Users can read own profile"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

create policy "Users can update own profile"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "Users can read own favorites"
on public.animal_favorites
for select
to authenticated
using (auth.uid() = user_id);

create policy "Users can insert own favorites"
on public.animal_favorites
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Users can delete own favorites"
on public.animal_favorites
for delete
to authenticated
using (auth.uid() = user_id);

create policy "Service role manages job schedules"
on public.job_schedules
for all
to service_role
using (true)
with check (true);

create policy "Service role manages job runs"
on public.job_runs
for all
to service_role
using (true)
with check (true);

create policy "Service role manages sync checkpoints"
on public.sync_checkpoints
for all
to service_role
using (true)
with check (true);

-- ========================================
-- Examples
-- ========================================

-- Profile example:
-- insert into public.profiles (id, display_name, avatar_url)
-- values (
--   '11111111-1111-1111-1111-111111111111',
--   'Ming',
--   'https://cdn.example.com/avatar.png'
-- );

-- Animal API mirror example:
-- insert into public.animals (
--   sub_id,
--   latest_animal_id,
--   animal_area_pkid,
--   animal_shelter_pkid,
--   name,
--   kind,
--   variety,
--   sex,
--   body_type,
--   age,
--   color,
--   status,
--   shelter_name,
--   shelter_address,
--   shelter_tel,
--   image_url,
--   raw_data
-- ) values (
--   'FAABG11207296003',
--   318716,
--   10,
--   68,
--   '小黃',
--   '狗',
--   '混種犬',
--   'F',
--   'MEDIUM',
--   'ADULT',
--   '黃色',
--   'OPEN',
--   '臺中市動物之家后里園區',
--   '臺中市后里區堤防路370號',
--   '04-25588024',
--   'https://www.pet.gov.tw/upload/pic/1691030858874.png',
--   '{"animal_id":318716,"animal_subid":"FAABG11207296003"}'::jsonb
-- );

-- Favorite example:
-- insert into public.animal_favorites (user_id, animal_sub_id)
-- values (
--   '11111111-1111-1111-1111-111111111111',
--   'FAABG11207296003'
-- );

-- Job schedule example:
-- insert into public.job_schedules (
--   job_key,
--   name,
--   description,
--   schedule_type,
--   cron_expression,
--   next_run_at,
--   meta
-- ) values (
--   'sync_animals_daily',
--   '每日同步動物資料',
--   '從農業部 API 拉最新動物認領養資料',
--   'cron',
--   '0 2 * * *',
--   now() + interval '1 day',
--   '{"source":"moa_api","top":1000}'::jsonb
-- );

-- Job run example:
-- insert into public.job_runs (
--   job_schedule_id,
--   status,
--   finished_at,
--   processed_count,
--   success_count,
--   failed_count,
--   message
-- ) values (
--   (select id from public.job_schedules where job_key = 'sync_animals_daily'),
--   'success',
--   now(),
--   1000,
--   998,
--   2,
--   '同步完成'
-- );

-- Sync checkpoint example:
-- insert into public.sync_checkpoints (
--   checkpoint_key,
--   checkpoint_value,
--   description,
--   meta
-- ) values (
--   'animals_last_synced_at',
--   '2026-05-02T02:00:00+00:00',
--   '上次成功同步農業部動物資料時間',
--   '{"source":"moa_api"}'::jsonb
-- )
-- on conflict (checkpoint_key) do update set
--   checkpoint_value = excluded.checkpoint_value,
--   meta = excluded.meta,
--   updated_at = now();

-- ========================================
-- Column comments
-- ========================================

comment on table public.profiles is '使用者延伸資料（對應 Supabase auth.users）';
comment on column public.profiles.id is '使用者 UUID（對應 auth.users.id）';
comment on column public.profiles.display_name is '顯示名稱';
comment on column public.profiles.avatar_url is '頭像網址';
comment on column public.profiles.created_at is '建立時間';
comment on column public.profiles.updated_at is '更新時間';

comment on table public.animals is '農業部動物認領養 API 快取鏡像資料';
comment on column public.animals.sub_id is '動物收容編號（穩定唯一鍵）';
comment on column public.animals.latest_animal_id is 'API 流水號（可能遞增變動）';
comment on column public.animals.animal_area_pkid is '縣市代碼';
comment on column public.animals.animal_shelter_pkid is '收容所代碼';
comment on column public.animals.name is '動物名稱或顯示名稱';
comment on column public.animals.kind is '動物類型（狗、貓...）';
comment on column public.animals.variety is '品種';
comment on column public.animals.sex is '性別（M/F/N）';
comment on column public.animals.body_type is '體型（SMALL/MEDIUM/BIG）';
comment on column public.animals.age is '年齡（CHILD/ADULT）';
comment on column public.animals.color is '毛色';
comment on column public.animals.animal_place is '實際所在地';
comment on column public.animals.found_place is '尋獲地點';
comment on column public.animals.title is '動物標題';
comment on column public.animals.status is '狀態（OPEN/ADOPTED...）';
comment on column public.animals.remark is '備註';
comment on column public.animals.caption is '其他說明';
comment on column public.animals.sterilization is '是否絕育';
comment on column public.animals.bacterin is '是否施打狂犬病疫苗';
comment on column public.animals.open_date is '開放認養起始日';
comment on column public.animals.closed_date is '開放認養截止日';
comment on column public.animals.animal_update is '動物資料異動時間（來源字串）';
comment on column public.animals.animal_create_time is '動物資料建立時間（來源字串）';
comment on column public.animals.cdate is '來源資料更新時間';
comment on column public.animals.album_update is '圖片異動時間';
comment on column public.animals.shelter_name is '收容所名稱';
comment on column public.animals.shelter_address is '收容所地址';
comment on column public.animals.shelter_tel is '收容所電話';
comment on column public.animals.image_url is '圖片網址';
comment on column public.animals.raw_data is '原始 API JSON 資料';
comment on column public.animals.synced_at is '同步時間';
comment on column public.animals.updated_at is '更新時間';

comment on table public.animal_favorites is '使用者收藏動物關聯表';
comment on column public.animal_favorites.id is '收藏紀錄 UUID';
comment on column public.animal_favorites.user_id is '使用者 UUID';
comment on column public.animal_favorites.animal_sub_id is '動物收容編號';
comment on column public.animal_favorites.created_at is '收藏時間';

comment on table public.job_schedules is '排程工作設定';
comment on column public.job_schedules.id is '排程 UUID';
comment on column public.job_schedules.job_key is '排程唯一代碼';
comment on column public.job_schedules.name is '排程名稱';
comment on column public.job_schedules.description is '排程描述';
comment on column public.job_schedules.is_enabled is '是否啟用';
comment on column public.job_schedules.schedule_type is '排程類型（cron/interval/manual）';
comment on column public.job_schedules.cron_expression is 'Cron 表達式';
comment on column public.job_schedules.interval_minutes is '分鐘間隔';
comment on column public.job_schedules.last_run_at is '上次執行時間';
comment on column public.job_schedules.next_run_at is '下次執行時間';
comment on column public.job_schedules.last_status is '上次執行狀態';
comment on column public.job_schedules.last_error is '上次錯誤訊息';
comment on column public.job_schedules.run_count is '累計執行次數';
comment on column public.job_schedules.meta is '額外設定 JSON';
comment on column public.job_schedules.created_at is '建立時間';
comment on column public.job_schedules.updated_at is '更新時間';

comment on table public.job_runs is '排程每次執行紀錄';
comment on column public.job_runs.id is '執行紀錄 UUID';
comment on column public.job_runs.job_schedule_id is '對應排程 UUID';
comment on column public.job_runs.status is '執行狀態';
comment on column public.job_runs.started_at is '開始時間';
comment on column public.job_runs.finished_at is '結束時間';
comment on column public.job_runs.processed_count is '處理總數';
comment on column public.job_runs.success_count is '成功筆數';
comment on column public.job_runs.failed_count is '失敗筆數';
comment on column public.job_runs.message is '執行訊息';
comment on column public.job_runs.error is '錯誤內容';
comment on column public.job_runs.meta is '額外執行資訊 JSON';
comment on column public.job_runs.created_at is '建立時間';

comment on table public.sync_checkpoints is '同步進度檢查點';
comment on column public.sync_checkpoints.checkpoint_key is '檢查點鍵值';
comment on column public.sync_checkpoints.checkpoint_value is '檢查點內容';
comment on column public.sync_checkpoints.description is '描述';
comment on column public.sync_checkpoints.meta is '額外資訊 JSON';
comment on column public.sync_checkpoints.updated_at is '更新時間';