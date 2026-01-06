-- Create profiles_u table and supporting indexes
create table if not exists public.profiles_u (
  username text primary key,
  name text,
  bio text,
  gender text,
  dob date,
  address text,
  email text,
  phone text,
  photo_url text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

-- Update trigger to keep updated_at fresh
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_profiles_u_updated_at on public.profiles_u;
create trigger trg_profiles_u_updated_at
before update on public.profiles_u
for each row execute function public.set_updated_at();

-- Helpful index for email/phone lookups (optional)
create index if not exists idx_profiles_u_email on public.profiles_u (email);
create index if not exists idx_profiles_u_phone on public.profiles_u (phone);

-- Note: copying from an existing 'profiles' table varies by schema.
-- Run this optional snippet separately if your existing table has a 'username' column:
-- do $$
-- begin
--   if exists (
--     select 1 from information_schema.columns
--     where table_schema='public' and table_name='profiles' and column_name='username'
--   ) then
--     insert into public.profiles_u (username)
--     select username from public.profiles
--     on conflict (username) do nothing;
--   end if;
-- end$$;
