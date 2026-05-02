alter table public.animals
add column if not exists last_seen_run_id text,
add column if not exists last_seen_at timestamptz,
add column if not exists missing_sync_count int not null default 0,
add column if not exists is_in_shelter boolean not null default true,
add column if not exists left_shelter_at timestamptz;

create index if not exists idx_animals_is_in_shelter on public.animals(is_in_shelter);
create index if not exists idx_animals_missing_sync_count on public.animals(missing_sync_count);
create index if not exists idx_animals_last_seen_run_id on public.animals(last_seen_run_id);

comment on column public.animals.last_seen_run_id is '最後一次在同步批次中出現的 run id';
comment on column public.animals.last_seen_at is '最後一次在來源 API 被看到的時間';
comment on column public.animals.missing_sync_count is '連續同步未出現次數';
comment on column public.animals.is_in_shelter is '是否仍在收容所（依同步規則推估）';
comment on column public.animals.left_shelter_at is '被標記為離開收容所的時間';

create or replace function public.apply_animals_absence(
  p_sync_run_id text,
  p_threshold int,
  p_mark_at timestamptz
)
returns table(marked_missing_count int, marked_leave_count int)
language plpgsql
as $$
declare
  v_marked_missing_count int := 0;
  v_marked_leave_count int := 0;
begin
  if p_threshold < 1 then
    raise exception 'p_threshold must be >= 1';
  end if;

  with updated as (
    update public.animals a
    set missing_sync_count = a.missing_sync_count + 1
    where coalesce(a.last_seen_run_id, '') <> p_sync_run_id
    returning a.sub_id, a.missing_sync_count, a.is_in_shelter
  )
  select count(*)::int
    into v_marked_missing_count
  from updated;

  with eligible as (
    select a.sub_id
    from public.animals a
    where coalesce(a.last_seen_run_id, '') <> p_sync_run_id
      and a.is_in_shelter = true
      and a.missing_sync_count >= p_threshold
  ),
  lefted as (
    update public.animals a
    set is_in_shelter = false,
        left_shelter_at = coalesce(a.left_shelter_at, p_mark_at)
    from eligible e
    where a.sub_id = e.sub_id
    returning a.sub_id
  )
  select count(*)::int
    into v_marked_leave_count
  from lefted;

  return query
  select v_marked_missing_count, v_marked_leave_count;
end;
$$;
