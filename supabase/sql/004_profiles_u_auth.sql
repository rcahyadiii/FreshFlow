-- Add auth_uid to profiles_u and link to Supabase Auth
alter table public.profiles_u
  add column if not exists auth_uid uuid unique;

-- Add the FK constraint if it does not already exist (Postgres doesn't support IF NOT EXISTS here)
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'fk_profiles_u_auth'
  ) then
    alter table public.profiles_u
      add constraint fk_profiles_u_auth
      foreign key (auth_uid) references auth.users(id)
      on delete set null;
  end if;
end$$;

create index if not exists idx_profiles_u_auth_uid on public.profiles_u(auth_uid);
