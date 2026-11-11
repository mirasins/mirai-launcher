# Mirai Launcher app icon

The app icon is the **Mirai mark**: a purple geometric "M" under a small lilac diamond, original to
this fork and licensed like the code (MIT OR Apache-2.0). Its source is `artcraft-launcher.svg` (the
file keeps upstream's name, which packaging and the build refer to). It replaces the ArtCraft
"A" mark, which forks must not ship.

## Files

- `artcraft-launcher.svg`: the source; also the hicolor scalable icon.
- `artcraft-launcher-1024.png`: 1024 px render, with extra transparent margin for Apple's icon grid.
- `artcraft-launcher.icns`: macOS bundle icon (`CFBundleIconFile`).
- `artcraft-launcher.ico`: Windows icon, 16–256 px, embedded in the `.exe` by
  `apps/artcraft-launcher/build.rs` and used by the MSI.
- `hicolor/<size>/apps/ai.storyteller.artcraft-launcher.png` (16–512) and
  `hicolor/scalable/apps/ai.storyteller.artcraft-launcher.svg`: Linux icon theme.
- `tray-64.png` (Windows, Linux, FreeBSD) and `tray-black-44.png` (the macOS menu-bar template,
  22 pt @2x): the tray icon.
- `mirai-wordmark-white.png`: "Mirai" set in Archivo (OFL-1.1, `assets/fonts`), for the Windows
  installer's dark panel.

## Regenerate

Run `packaging/icons.sh` on any OS. It renders the source with `resvg` and packs the `.ico` and
`.icns` with `cargo xtask ico` / `cargo xtask icns`. Change the source SVG, never the renders.
