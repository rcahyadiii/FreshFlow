-- Reports (username-keyed)
create extension if not exists pgcrypto;

create table if not exists public.reports_u (
  id uuid primary key default gen_random_uuid(),
  username text not null,
  date timestamptz not null default now(),
  address text not null,
  images jsonb not null default '[]'::jsonb,
  videos jsonb not null default '[]'::jsonb,
  description text not null,
  categories jsonb not null default '[]'::jsonb,
  completed boolean not null default false,
  rating int,
  review text,
  resolve_images jsonb not null default '[]'::jsonb,
  resolve_description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists reports_u_username_idx on public.reports_u(username);
create index if not exists reports_u_created_idx on public.reports_u(created_at desc);

create or replace function public.touch_reports_u()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_reports_u_touch on public.reports_u;
create trigger trg_reports_u_touch before update on public.reports_u
for each row execute function public.touch_reports_u();
