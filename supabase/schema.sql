-- CRM de Prospecção PCBH: banco e permissões.
-- Cole este arquivo inteiro no Supabase: SQL Editor > New query > Run.
-- ANTES de rodar, troque os e-mails e nomes no final pelos reais.

create table if not exists public.docs (
  collection text not null,
  id         text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);

create table if not exists public.allowed_users (
  email text primary key,
  nome  text not null default '',
  role  text not null default 'vendas' check (role in ('admin','vendas'))
);

alter table public.docs enable row level security;
alter table public.allowed_users enable row level security;
-- allowed_users não tem política: ninguém lê pela API. Só as funções abaixo consultam.

create or replace function public.is_allowed() returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from public.allowed_users where lower(email) = lower(auth.jwt() ->> 'email'))
$$;

create or replace function public.my_role() returns text
language sql security definer stable set search_path = public as $$
  select role from public.allowed_users where lower(email) = lower(auth.jwt() ->> 'email')
$$;

-- Nomes da equipe, para mostrar "movido por Flávia" nos cards.
create or replace function public.team_names() returns table(email text, nome text)
language sql security definer stable set search_path = public as $$
  select lower(u.email), u.nome from public.allowed_users u where public.is_allowed()
$$;

drop policy if exists docs_acesso on public.docs;
create policy docs_acesso on public.docs for all to authenticated
  using (public.is_allowed()) with check (public.is_allowed());

revoke all on function public.is_allowed() from public, anon;
revoke all on function public.my_role() from public, anon;
revoke all on function public.team_names() from public, anon;
grant execute on function public.is_allowed() to authenticated;
grant execute on function public.my_role() to authenticated;
grant execute on function public.team_names() to authenticated;

-- Atualização em tempo real entre as vendedoras.
alter table public.docs replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;

-- Quem pode entrar. TROQUE OS E-MAILS (e crie os mesmos usuários em Authentication > Users).
insert into public.allowed_users (email, nome, role) values
  ('TROQUE_EMAIL_FILIPE@exemplo.com', 'Filipe', 'admin'),
  ('TROQUE_EMAIL_FLAVIA@exemplo.com', 'Flávia', 'vendas'),
  ('TROQUE_EMAIL_YASMIN@exemplo.com', 'Yasmin', 'vendas')
on conflict (email) do update set nome = excluded.nome, role = excluded.role;
