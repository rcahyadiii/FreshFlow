-- Water info, FAQs, and tips (app-specific, username optional)
create extension if not exists pgcrypto;

create table if not exists public.water_info_u (
  id uuid primary key default gen_random_uuid(),
  username text,
  location_name text,
  quality_rate double precision not null default 0,
  flow_status text not null default 'Unknown',
  ph double precision not null default 7,
  likes int not null default 0,
  dislikes int not null default 0,
  trend jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

create index if not exists water_info_u_username_idx on public.water_info_u(username);
create index if not exists water_info_u_updated_idx on public.water_info_u(updated_at desc);

create table if not exists public.faqs_u (
  id uuid primary key default gen_random_uuid(),
  question text not null,
  answer text not null,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists faqs_u_sort_idx on public.faqs_u(sort_order);

create table if not exists public.tips_u (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text,
  image_url text,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists tips_u_sort_idx on public.tips_u(sort_order);
