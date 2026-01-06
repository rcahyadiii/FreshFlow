-- Notifications + settings (username-keyed) migration
create extension if not exists pgcrypto;

create table if not exists public.notifications_u (
  id uuid primary key default gen_random_uuid(),
  username text not null,
  title text not null,
  body text not null,
  created_at timestamptz not null default now(),
  is_read boolean not null default false
);

create index if not exists notifications_u_username_idx on public.notifications_u(username);
create index if not exists notifications_u_created_idx on public.notifications_u(created_at desc);

create table if not exists public.notification_settings_u (
  username text primary key,
  message boolean not null default true,
  sound boolean not null default true,
  email boolean not null default false,
  sms boolean not null default false,
  whatsapp boolean not null default true,
  updated_at timestamptz not null default now()
);

create or replace function public.set_notification_settings_u(
  p_username text,
  p_message boolean,
  p_sound boolean,
  p_email boolean,
  p_sms boolean,
  p_whatsapp boolean
)
returns void
language plpgsql
as $$
begin
  insert into public.notification_settings_u (username, message, sound, email, sms, whatsapp)
  values (p_username, p_message, p_sound, p_email, p_sms, p_whatsapp)
  on conflict (username) do update set
    message = excluded.message,
    sound = excluded.sound,
    email = excluded.email,
    sms = excluded.sms,
    whatsapp = excluded.whatsapp,
    updated_at = now();
end;
$$;
