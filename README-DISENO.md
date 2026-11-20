# Johannes Gutenberg — versión visual

Esta carpeta contiene la aplicación original con una nueva capa de diseño inspirada en el logo proporcionado.

## Archivos principales
- `index.html`: interfaz y lógica de ventas, eventos, panel y productos.
- `logo-referencia.png`: imagen original compartida para identidad visual.
- `icon.svg`: icono simplificado para instalar la app (reinterpretación, no reproducción exacta).
- `config.js`: completar con URL y clave pública de Supabase.
- `sw.js`: soporte sin conexión y actualización de caché.
- `manifest.json`: nombre y aspecto de la app instalable.
- `supabase/schema.sql`: esquema y políticas de base de datos existentes.
- `vercel.json`: configuración de despliegue.

## Para publicar
1. Haz una copia de seguridad del proyecto y base de datos actuales.
2. Configura `config.js` con los datos públicos de tu proyecto Supabase. No uses la clave `service_role`.
3. Sube los archivos a un repositorio de GitHub y despliega en Vercel (framework: Other).
4. Prueba inicio de sesión, registro, eventos, cobro, gráficos y sincronización offline antes de usarlo en producción.

## Alcance
Se actualizó la identidad visual, el logo de inicio y cabecera, el icono, los colores y el manifiesto. Se preservó la lógica de la aplicación original; **no se han ejecutado pruebas end-to-end con Supabase ni en dispositivos reales**. Los productos del mockup son ilustrativos y no se agregan automáticamente al catálogo.
