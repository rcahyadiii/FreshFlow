-- Profiles keyed by username (demo-friendly; replace with auth.users in production)
create table if not exists public.profiles_u (
  username text primary key,
  name text,
  bio text,
  gender text,
  dob date,
  photo_url text,
  address text,
  email text,
  phone text,
  updated_at timestamptz not null default now()
);

-- For development, RLS disabled (open). Enable and add policies for production.
-- alter table public.profiles_u enable row level security;