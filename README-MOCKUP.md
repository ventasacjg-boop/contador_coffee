# Johannes Gutenberg — interfaz inspirada en el mockup

Esta versión actualiza el diseño de la app para acercarlo al mockup aprobado: marca Johannes Gutenberg, azul eléctrico, amarillo y rojo, menú lateral, tarjetas visuales de productos, búsqueda y filtros, panel de métricas y barra de cobro.

## Diferencias respecto al mockup
Las cifras y productos del mockup eran ejemplos. Esta aplicación muestra los datos reales de Supabase. Las tarjetas usan ilustraciones por categoría inferida del nombre del producto, porque el esquema actual no almacena fotografías ni categorías; para fotos idénticas a las del mockup habría que añadir imágenes y categorías al catálogo.

## Instalación
Completar `config.js` con la URL y clave pública de Supabase. Conservar la estructura de archivos al subir a GitHub/Vercel. No incluir una clave `service_role` en el frontend.

## Validación pendiente
No se ha podido probar la conexión real a Supabase ni el flujo de cobro en producción. Probar login, ventas, eventos, sincronización offline y gráficos antes de reemplazar la versión activa.
