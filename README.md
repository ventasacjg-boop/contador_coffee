# Caja Gutenberg

App web para registrar ventas desde el celular, ver el historial y revisar un panel con los números. Varias personas pueden vender a la vez y todo se junta en un mismo lugar.

Hecha con HTML + JavaScript (sin compilar nada), Supabase como base de datos y login, GitHub para el código y Vercel para publicarla.

## Qué hace

- **Vender:** eliges si es **venta diaria** o de un **evento**. Los eventos los crea cualquiera y aparecen al toque en todos los celulares. Tocas los productos, ajustas con − y +, y al cobrar pones el nombre del cliente (opcional), si es mujer u hombre, cómo pagó y comentarios. Sale un ticket en pantalla como confirmación.
- **Ventas:** historial por día con filtros (hoy, 7 días, mes, todo), por tipo o por evento, y "solo mías". Cada persona puede borrar solo las ventas que registró.
- **Descargar Excel:** eliges si quieres todas las ventas, las de un día, las de un evento o solo las tuyas. El archivo trae una hoja por venta y otra con el detalle por producto.
- **Panel:** total (separando diarias y eventos), ventas, promedio, unidades, gráfico por día o por hora, ranking de eventos, productos más vendidos, medios de pago, mujeres vs. hombres, horas con más ventas y ranking por vendedor.
- **Mi cuenta:** el círculo con tu inicial arriba a la derecha muestra tus ventas de hoy, te deja cambiar tu nombre y cerrar sesión.
- **Productos:** agregar, cambiar precio o nombre, ocultar los que ya no se venden.
- **Sin internet:** si se cae la señal, la venta se guarda en el celular y se sube sola cuando vuelve la conexión (arriba a la derecha se ve el estado).

## Estructura

```
caja-gutenberg/
├── index.html          la app completa
├── config.js           URL y llave de Supabase (lo único que editas)
├── sw.js               permite abrir la app sin internet
├── manifest.json       para instalarla en la pantalla de inicio
├── icon.svg            ícono
├── vercel.json         configuración de caché para Vercel
└── supabase/
    └── schema.sql      tablas y permisos de la base de datos
```

## Actualizar desde la versión anterior

Si ya tenías la app funcionando: corre otra vez todo `supabase/schema.sql` en el SQL Editor (no borra nada, solo agrega eventos y los campos nuevos) y sube los archivos nuevos a GitHub.

## Paso 1: Supabase

1. Entra a [supabase.com](https://supabase.com), crea un proyecto nuevo (elige la región más cercana, por ejemplo São Paulo) y guarda la contraseña de la base de datos.
2. Ve a **SQL Editor > New query**, pega todo el contenido de `supabase/schema.sql` y dale **Run**.
3. Ve a **Authentication > Sign In / Providers > Email**: deja activado **Allow new users to sign up** (cada persona crea su cuenta desde la app) y desactiva **Confirm email** para que puedan entrar al toque. Cuando ya estén todos registrados, puedes apagar el registro.
4. (Opcional) También puedes crear cuentas tú misma en **Authentication > Users > Add user > Create new user**, marcando **Auto Confirm User**.
5. Ve a **Project Settings > API** y copia el **Project URL** y la **anon public key**.
6. Pégalos en `config.js`.

## Paso 2: GitHub

1. Crea un repositorio nuevo (puede ser privado), por ejemplo `caja-gutenberg`.
2. Sube todos los archivos de esta carpeta (con **Add file > Upload files** o con git):

```bash
git init
git add .
git commit -m "Caja Gutenberg: primera versión"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/caja-gutenberg.git
git push -u origin main
```

## Paso 3: Vercel

1. Entra a [vercel.com](https://vercel.com) con tu cuenta de GitHub.
2. **Add New > Project**, elige el repositorio `caja-gutenberg` e **Import**.
3. En **Framework Preset** deja **Other**. No hace falta build command ni output directory.
4. **Deploy**. En un minuto te da un link tipo `caja-gutenberg.vercel.app`.

Cada vez que subas un cambio a GitHub, Vercel publica la nueva versión solo.

## Paso 4: en el celular

1. Abre el link en el navegador del celular y entra con tu cuenta.
2. En **Productos**, escribe tu nombre (así sale en las ventas) y agrega el catálogo.
3. Instálala como app:
   - **Android (Chrome):** menú ⋮ > **Agregar a la pantalla principal**.
   - **iPhone (Safari):** botón compartir > **Agregar a inicio**.

## Bueno saber

- La **anon key** de `config.js` es pública por diseño; lo que protege los datos son las políticas del `schema.sql` (solo usuarios con cuenta leen y escriben, y cada uno borra solo sus ventas).
- Si alguien cierra sesión con ventas pendientes por subir, se quedan guardadas en ese celular y se suben cuando vuelva a entrar.
- Para cambiar quién puede editar productos o borrar ventas, se ajustan las políticas en `schema.sql`.
