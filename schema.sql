-- =========================================================
-- Caja Gutenberg — esquema de base de datos (Supabase)
-- Pega todo esto en: Supabase > SQL Editor > New query > Run
-- =========================================================

create extension if not exists pgcrypto;

-- ---------- Productos (el catálogo que se ve en "Vender") ----------
create table if not exists public.productos (
  id          uuid primary key default gen_random_uuid(),
  nombre      text not null,
  precio      numeric(10,2) not null check (precio >= 0),
  activo      boolean not null default true,
  orden       int not null default 0,
  created_at  timestamptz not null default now()
);

-- ---------- Ventas (una fila por producto vendido) ----------
-- Varias filas con el mismo ticket_id = una sola venta con varios productos.
create table if not exists public.ventas (
  id           uuid primary key default gen_random_uuid(),
  client_id    text not null unique,               -- evita duplicados al sincronizar ventas hechas sin internet
  ticket_id    uuid not null,
  producto_id  uuid references public.productos(id) on delete set null,
  producto     text not null,                      -- nombre guardado tal cual al momento de vender
  precio       numeric(10,2) not null check (precio >= 0),
  cantidad     int not null check (cantidad > 0),
  subtotal     numeric(12,2) generated always as (precio * cantidad) stored,
  metodo_pago  text not null check (metodo_pago in ('efectivo','yape_plin','transferencia','tarjeta')),
  nota         text,
  vendedor_id  uuid not null default auth.uid() references auth.users(id),
  vendedor     text not null,
  created_at   timestamptz not null default now()
);

create index if not exists ventas_created_at_idx on public.ventas (created_at desc);
create index if not exists ventas_ticket_idx     on public.ventas (ticket_id);

-- ---------- Seguridad (Row Level Security) ----------
-- Solo personas con cuenta (que tú creas en Authentication > Users) pueden entrar.
alter table public.productos enable row level security;
alter table public.ventas    enable row level security;

drop policy if exists "ver productos"     on public.productos;
drop policy if exists "crear productos"   on public.productos;
drop policy if exists "editar productos"  on public.productos;
drop policy if exists "ver ventas"        on public.ventas;
drop policy if exists "registrar ventas"  on public.ventas;
drop policy if exists "borrar mis ventas" on public.ventas;

create policy "ver productos"    on public.productos for select to authenticated using (true);
create policy "crear productos"  on public.productos for insert to authenticated with check (true);
create policy "editar productos" on public.productos for update to authenticated using (true) with check (true);

-- Todos ven todas las ventas (para el panel), pero cada quien registra a su nombre
-- y solo puede borrar las ventas que registró.
create policy "ver ventas"        on public.ventas for select to authenticated using (true);
create policy "registrar ventas"  on public.ventas for insert to authenticated with check (vendedor_id = auth.uid());
create policy "borrar mis ventas" on public.ventas for delete to authenticated using (vendedor_id = auth.uid());

-- ---------- Productos de ejemplo (opcional, bórralos o cámbialos) ----------
-- insert into public.productos (nombre, precio, orden) values
--   ('Producto 1', 5.00, 1),
--   ('Producto 2', 8.50, 2),
--   ('Producto 3', 12.00, 3);
