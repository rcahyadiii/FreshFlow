-- Chat persistence (username-keyed conversations)
create extension if not exists pgcrypto;

create table if not exists public.chat_conversations_u (
  id uuid primary key default gen_random_uuid(),
  username text not null,
  title text,
  created_at timestamptz not null default now()
);

create index if not exists chat_conversations_u_username_idx on public.chat_conversations_u(username);

create table if not exists public.chat_messages_u (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.chat_conversations_u(id) on delete cascade,
  role text not null check (role in ('user','assistant','system')),
  content text not null,
  created_at timestamptz not null default now()
);

create index if not exists chat_messages_u_conv_idx on public.chat_messages_u(conversation_id, created_at);
