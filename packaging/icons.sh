#!/usr/bin/env bash
# Regenerate every app and tray icon from the Mirai mark, assets/app-icon/artcraft-launcher.svg
# (original to the Mirai fork, MIT OR Apache-2.0; see assets/app-icon/README.md).
#
# - App icon (Dock, taskbar, Start menu, Linux menus, installers): the mark in colour.
# - Tray: a black copy as the macOS menu-bar template; the mark in colour on Windows, Linux and BSD.
#
# Needs: resvg (brew install resvg / cargo install resvg). The .ico and .icns are packed by
# `cargo xtask ico` / `cargo xtask icns`, so this runs on any OS. The outputs are committed, so
# packaging (and the Rust build, which include_bytes!s some of them) never needs these tools.
#
#   packaging/icons.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="$ROOT/assets/app-icon"
SRC="$TMP/mark.svg"
ID="ai.storyteller.artcraft-launcher"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cp "$DIR/artcraft-launcher.svg" "$TMP/mark.svg"

command -v resvg >/dev/null || { echo "error: resvg not found (brew install resvg)" >&2; exit 1; }

# macOS icons get a little more transparent margin (Apple's 824/1024 icon grid) by widening the
# view box; everything else uses the file as is.
BOX='viewBox="0 0 128 128"'
grep -q "$BOX" "$SRC" || { echo "error: expected $BOX in $SRC" >&2; exit 1; }
MAC="$TMP/mac.svg"
sed "s/$BOX/viewBox=\"-12.8 -12.8 153.6 153.6\"/" "$SRC" >"$MAC"
FLAT="$SRC"

render() {
  local src="$1" size="$2" out="$3"
  resvg -w "$size" -h "$size" "$src" "$out" </dev/null
}

render "$MAC" 1024 "$DIR/artcraft-launcher-1024.png"

# Linux hicolor theme.
for s in 16 24 32 48 64 128 256 512; do
  mkdir -p "$DIR/hicolor/${s}x${s}/apps"
  render "$FLAT" "$s" "$DIR/hicolor/${s}x${s}/apps/$ID.png"
done
mkdir -p "$DIR/hicolor/scalable/apps"
cp "$SRC" "$DIR/hicolor/scalable/apps/$ID.svg"

# Windows .ico.
ICO_PNGS=()
for s in 16 20 24 32 40 48 64 128 256; do
  render "$FLAT" "$s" "$TMP/ico-$s.png"
  ICO_PNGS+=("$TMP/ico-$s.png")
done
(cd "$ROOT" && cargo run -q -p xtask -- ico "$DIR/artcraft-launcher.ico" "${ICO_PNGS[@]}")

# macOS .icns.
ICNS_PNGS=()
for s in 16 32 64 128 256 512 1024; do
  render "$MAC" "$s" "$TMP/icns-$s.png"
  ICNS_PNGS+=("$TMP/icns-$s.png")
done
(cd "$ROOT" && cargo run -q -p xtask -- icns "$DIR/artcraft-launcher.icns" "${ICNS_PNGS[@]}")

# Tray icons: a black copy is the macOS menu-bar template (44 px = 22 pt @2x; macOS tints it);
# the colour mark is for the Windows notification area and Linux/BSD status notifiers.
sed -E 's/fill="#[0-9a-fA-F]{6}"/fill="#000000"/g' "$SRC" >"$TMP/black.svg"
render "$TMP/black.svg" 44 "$DIR/tray-black-44.png"
render "$SRC" 64 "$DIR/tray-64.png"
echo "icons written to $DIR"
