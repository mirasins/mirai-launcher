# Mirai — Descargas

Web estática independiente de la aplicación nativa, basada en gh-pages (47fd3aa1238b24d3fb9be03969b95356a2dd3aba). No necesita compilación ni dependencias externas. Abrir index.html o servir la carpeta mediante HTTP.

## Publicación

Publicar únicamente después de la aprobación del propietario, conservando la raíz de gh-pages en GitHub Pages. No se modifican la aplicación Rust ni sus workflows.

## Interacción y accesibilidad

El contenido y todos los enlaces están en HTML. script.js solo añade entradas progresivas con IntersectionObserver y un control para pausar animaciones. Sin JavaScript, con error de script o sin IntersectionObserver, los bloques siguen visibles. Las animaciones respetan prefers-reduced-motion tanto en CSS como en JavaScript, incluidos los cambios de preferencia con la página abierta. No hay librerías de animación, fuentes externas, rastreo, cursores especiales ni pantallas de carga.

## Actualizar descargas

Consultar las releases públicas de los cinco repositorios. Usar browser_download_url de cada asset; no reconstruir URLs ni inferir paquetes desde una etiqueta. Actualizar versiones por plataforma y fecha de revisión. Excluir borradores; una etiqueta Latest no demuestra disponibilidad para todos los sistemas.

Catálogo consultado el 15 de noviembre de 2026: Words v0.18.1-mirai.2, Calc v0.19.1-mirai.1, Presentations v0.19.0-mirai.1, Reader v0.21.1-mirai.1 y Launcher v0.19.3 ofrecen paquetes Windows x64 y ARM64, Linux y web. Las releases actuales de Windows usan certificados autofirmados; los paquetes Linux no están firmados. También se enlazan Presentations v0.15.1 y Launcher v0.19.2, sin firma. Consultar las notas de cada release antes de instalar.

## Recursos

Se conservan los cinco PNG originales, ATTRIBUTION.md, LICENSE-MIT y LICENSE-APACHE. El fondo, las conexiones y las formas decorativas son CSS/SVG originales de esta web. Fuentes del sistema.
