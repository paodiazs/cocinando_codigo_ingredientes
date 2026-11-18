-- =========================================================
-- Huerto del grupo · configuración de Supabase
-- Pega TODO esto en Supabase → SQL Editor → New query → Run
-- =========================================================

-- 1) Tabla
create table if not exists public.respuestas (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  nombre      text not null,
  background  text not null,
  cocina      text not null,
  ingrediente text not null,
  emoji       text not null default '🍅',
  x           real not null default 50,   -- posición horizontal en % del lienzo
  y           real not null default 50,   -- posición vertical en % del lienzo
  grande      boolean not null default false
);

-- Si ya tenías la tabla de antes, esto agrega lo que falte:
alter table public.respuestas add column if not exists x real not null default 50;
alter table public.respuestas add column if not exists y real not null default 50;
alter table public.respuestas add column if not exists grande boolean not null default false;

-- 2) Seguridad (RLS): cualquiera puede leer, agregar y mover/agrandar
alter table public.respuestas enable row level security;

drop policy if exists "leer respuestas"   on public.respuestas;
drop policy if exists "agregar respuestas" on public.respuestas;
drop policy if exists "mover respuestas"   on public.respuestas;

create policy "leer respuestas"    on public.respuestas for select to anon using (true);
create policy "agregar respuestas" on public.respuestas for insert to anon with check (true);
create policy "mover respuestas"   on public.respuestas for update to anon using (true) with check (true);

-- Desde la página solo se pueden cambiar x, y y grande (no el nombre ni las respuestas)
revoke update on public.respuestas from anon;
grant  update (x, y, grande) on public.respuestas to anon;

-- 3) Tiempo real (para que aparezcan y se muevan solos en el proyector)
-- Si marca "already member of publication", ignóralo: ya estaba activado.
alter publication supabase_realtime add table public.respuestas;
