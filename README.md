# Mirai — Descargas

Web estática independiente de la aplicación nativa, basada en gh-pages (47fd3aa1238b24d3fb9be03969b95356a2dd3aba). No necesita compilación ni dependencias externas. Abrir index.html o servir la carpeta mediante HTTP.

## Publicación

Publicar únicamente después de la aprobación del propietario, conservando la raíz de gh-pages en GitHub Pages. No se modifican la aplicación Rust ni sus workflows.

## Interacción y accesibilidad

El contenido y todos los enlaces están en HTML. script.js solo añade entradas progresivas con IntersectionObserver y un control para pausar animaciones. Sin JavaScript, con error de script o sin IntersectionObserver, los bloques siguen visibles. Las animaciones respetan prefers-reduced-motion tanto en CSS como en JavaScript, incluidos los cambios de preferencia con la página abierta. No hay librerías de animación, fuentes externas, rastreo, cursores especiales ni pantallas de carga.

## Actualizar descargas

Consultar las releases públicas de los cinco repositorios. Usar browser_download_url de cada asset; no reconstruir URLs ni inferir paquetes desde una etiqueta. Actualizar versiones por plataforma y fecha de revisión. Excluir borradores; una etiqueta Latest no demuestra disponibilidad para todos los sistemas.

Catálogo consultado el 13 de noviembre de 2026: Words v0.15.2-mirai.1, Presentations v0.15.1-mirai.1, Calc v0.16.1-mirai.1, con MSI/ZIP Windows x64 y RPM Fedora x86_64. Reader y Launcher sin releases públicas. Las notas de los paquetes Windows indican ausencia de firma, identidad MSI compartida con upstream y pruebas completas de instalación no realizadas; la página lo comunica antes de descargar.

## Recursos

Se conservan los cinco PNG originales, ATTRIBUTION.md, LICENSE-MIT y LICENSE-APACHE. El fondo, las conexiones y las formas decorativas son CSS/SVG originales de esta web. Fuentes del sistema.
