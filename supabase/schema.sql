-- =========================================================
-- Caja Gutenberg — esquema de base de datos (Supabase)
-- Pega todo en: Supabase > SQL Editor > New query > Run
-- Se puede correr varias veces: si ya existe algo, no lo borra,
-- solo agrega lo que falta (sirve para instalar o para actualizar).
-- =========================================================

create extension if not exists pgcrypto;

-- ---------- Productos ----------
create table if not exists public.productos (
  id          uuid primary key default gen_random_uuid(),
  nombre      text not null,
  precio      numeric(10,2) not null check (precio >= 0),
  activo      boolean not null default true,
  orden       int not null default 0,
  created_at  timestamptz not null default now()
);

-- ---------- Eventos (los crea cualquiera y aparecen para todos) ----------
create table if not exists public.eventos (
  id          uuid primary key default gen_random_uuid(),
  nombre      text not null,
  fecha       date not null default current_date,
  activo      boolean not null default true,
  creado_por  uuid default auth.uid() references auth.users(id),
  created_at  timestamptz not null default now()
);

-- ---------- Ventas (una fila por producto; mismo ticket_id = misma venta) ----------
create table if not exists public.ventas (
  id           uuid primary key default gen_random_uuid(),
  client_id    text not null unique,
  ticket_id    uuid not null,
  producto_id  uuid references public.productos(id) on delete set null,
  producto     text not null,
  precio       numeric(10,2) not null check (precio >= 0),
  cantidad     int not null check (cantidad > 0),
  subtotal     numeric(12,2) generated always as (precio * cantidad) stored,
  metodo_pago  text not null check (metodo_pago in ('efectivo','yape_plin','transferencia','tarjeta')),
  nota         text,
  vendedor_id  uuid not null default auth.uid() references auth.users(id),
  vendedor     text not null,
  created_at   timestamptz not null default now()
);

-- Columnas nuevas (venta diaria / por evento y datos del cliente)
alter table public.ventas add column if not exists tipo      text not null default 'diaria' check (tipo in ('diaria','evento'));
alter table public.ventas add column if not exists evento_id uuid references public.eventos(id) on delete set null;
alter table public.ventas add column if not exists evento    text;
alter table public.ventas add column if not exists cliente   text;
alter table public.ventas add column if not exists sexo      text check (sexo in ('hombre','mujer'));

create index if not exists ventas_created_at_idx on public.ventas (created_at desc);
create index if not exists ventas_ticket_idx     on public.ventas (ticket_id);
create index if not exists ventas_evento_idx     on public.ventas (evento_id);
create index if not exists ventas_vendedor_idx   on public.ventas (vendedor_id);

-- ---------- Seguridad (Row Level Security) ----------
alter table public.productos enable row level security;
alter table public.eventos   enable row level security;
alter table public.ventas    enable row level security;

drop policy if exists "ver productos"     on public.productos;
drop policy if exists "crear productos"   on public.productos;
drop policy if exists "editar productos"  on public.productos;
drop policy if exists "ver eventos"       on public.eventos;
drop policy if exists "crear eventos"     on public.eventos;
drop policy if exists "editar eventos"    on public.eventos;
drop policy if exists "ver ventas"        on public.ventas;
drop policy if exists "registrar ventas"  on public.ventas;
drop policy if exists "borrar mis ventas" on public.ventas;

create policy "ver productos"    on public.productos for select to authenticated using (true);
create policy "crear productos"  on public.productos for insert to authenticated with check (true);
create policy "editar productos" on public.productos for update to authenticated using (true) with check (true);

create policy "ver eventos"      on public.eventos for select to authenticated using (true);
create policy "crear eventos"    on public.eventos for insert to authenticated with check (true);
create policy "editar eventos"   on public.eventos for update to authenticated using (true) with check (true);

create policy "ver ventas"        on public.ventas for select to authenticated using (true);
create policy "registrar ventas"  on public.ventas for insert to authenticated with check (vendedor_id = auth.uid());
create policy "borrar mis ventas" on public.ventas for delete to authenticated using (vendedor_id = auth.uid());

-- ---------- Tiempo real: que los cambios aparezcan solos en todos los celulares ----------
do $$
declare t text;
begin
  foreach t in array array['productos','eventos','ventas'] loop
    begin
      execute format('alter publication supabase_realtime add table public.%I', t);
    exception when duplicate_object then null;
              when undefined_object then null;
    end;
  end loop;
end $$;
