# Control de Turnos

¡Buenas! Acá les dejo la base del proyecto estructurada y lista para que arranquemos a meter código.

## Base del proyecto
Ya dejé configurada una arquitectura modular para facilitar el escalado de la app:
* **Rutas:** Todo el manejo de navegación está extraído en `src/routes/routes.dart`.
* **Página de inicio:** Ya armé el `home_page.dart` con un menú dinámico (por ahora placeholders para las pantallas).
* **Diseño Responsive:** Creé una clase utilitaria (`responsive.dart`) para que los tamaños de la interfaz se calculen solos y no se nos rompa el diseño dependiendo del celu que usemos.
* **Español configurado:** El soporte para fechas y texto en español ya está configurado.