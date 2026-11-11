# Mirai Launcher app icon

The app icon is the **Mirai Launcher icon**: a glossy pink-to-violet orb with the word "Mirai" in
white. It was supplied by the fork's owner, is original to this fork and is licensed like the code (MIT OR Apache-2.0). It replaces the
ArtCraft "A" mark, which forks must not ship.

The owner supplied two masters, kept here under upstream's file names (packaging and the build
refer to them):

- `artcraft-launcher.svg`: the vector master (512 px view box); also the hicolor scalable icon and
  the mark drawn in the window header.
- `artcraft-launcher-1024.png`: the 1024 px raster master. Every PNG, the `.ico` and the `.icns` are scaled down from it.

## Files

- `artcraft-launcher.icns`: macOS bundle icon (`CFBundleIconFile`). The orb already sits inside
  Apple's icon grid, so it needs no extra margin.
- `artcraft-launcher.ico`: Windows icon, 16–256 px, embedded in the `.exe` by
  `apps/artcraft-launcher/build.rs` and used by the MSI.
- `hicolor/<size>/apps/ai.storyteller.artcraft-launcher.png` (16–512) and
  `hicolor/scalable/apps/ai.storyteller.artcraft-launcher.svg`: Linux icon theme.
- `tray-64.png` (Windows, Linux, FreeBSD): the icon. `tray-black-44.png`: the macOS menu-bar
  template (22 pt @2x): the orb as a black disc with the lettering cut out.
- `mirai-wordmark-white.png`: "Mirai" set in Archivo (OFL-1.1, `assets/fonts`), for the Windows
  installer's dark panel.

## Regenerate

Run `packaging/icons.sh` on any OS after replacing the masters. It needs Python 3 with Pillow and
packs the `.ico` and `.icns` with `cargo xtask ico` / `cargo xtask icns`. Never edit the renders by
hand.
