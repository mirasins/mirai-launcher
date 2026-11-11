#!/usr/bin/env bash
# Regenerate every app and tray icon from the Mirai Launcher icon's raster master,
# assets/app-icon/artcraft-launcher-1024.png (supplied by the fork's owner, MIT OR Apache-2.0;
# see assets/app-icon/README.md). The SVG master is copied as the hicolor scalable icon.
#
# Needs: Python 3 with Pillow. The .ico and .icns are packed by `cargo xtask ico` /
# `cargo xtask icns`, so this runs on any OS. The outputs are committed, so packaging (and the
# Rust build, which include_bytes!s some of them) never needs these tools.
#
#   packaging/icons.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="$ROOT/assets/app-icon"
ID="ai.storyteller.artcraft-launcher"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 - "$DIR" "$ID" "$TMP" <<'PY'
import os, sys
from PIL import Image

d, app_id, tmp = sys.argv[1:4]
master = Image.open(os.path.join(d, "artcraft-launcher-1024.png")).convert("RGBA")

def down(size, out):
    master.resize((size, size), Image.LANCZOS).save(out)

for s in (16, 24, 32, 48, 64, 128, 256, 512):
    os.makedirs(os.path.join(d, "hicolor", f"{s}x{s}", "apps"), exist_ok=True)
    down(s, os.path.join(d, "hicolor", f"{s}x{s}", "apps", app_id + ".png"))
for s in (16, 20, 24, 32, 40, 48, 64, 128, 256):
    down(s, os.path.join(tmp, f"ico-{s}.png"))
for s in (16, 32, 64, 128, 256, 512, 1024):
    down(s, os.path.join(tmp, f"icns-{s}.png"))
down(64, os.path.join(d, "tray-64.png"))

# The macOS menu-bar template (44 px = 22 pt @2x; macOS tints it): the orb as a black disc with
# its white "Mirai" lettering (the band 0.45..0.65 of the height) knocked out.
n = master.size[0]
px = master.load()
mask = Image.new("L", master.size, 0)
m = mask.load()
for y in range(n):
    for x in range(n):
        r, g, b, a = px[x, y]
        text = r > 240 and g > 240 and b > 240 and a > 200 and 0.45 * n < y < 0.65 * n
        m[x, y] = 0 if text else a
rad = n * 211 / 512  # the orb's radius in the SVG master
c = n / 2
mask = mask.crop(tuple(int(round(v)) for v in (c - rad, c - rad, c + rad, c + rad)))
disc = Image.new("RGBA", mask.size, (0, 0, 0, 255))
disc.putalpha(mask)
tray = Image.new("RGBA", (44, 44), (0, 0, 0, 0))
tray.alpha_composite(disc.resize((42, 42), Image.LANCZOS), (1, 1))
tray.save(os.path.join(d, "tray-black-44.png"))
PY

mkdir -p "$DIR/hicolor/scalable/apps"
cp "$DIR/artcraft-launcher.svg" "$DIR/hicolor/scalable/apps/$ID.svg"

(cd "$ROOT" && cargo run -q -p xtask -- ico "$DIR/artcraft-launcher.ico" "$TMP"/ico-{16,20,24,32,40,48,64,128,256}.png)
(cd "$ROOT" && cargo run -q -p xtask -- icns "$DIR/artcraft-launcher.icns" "$TMP"/icns-{16,32,64,128,256,512,1024}.png)
echo "icons written to $DIR"
