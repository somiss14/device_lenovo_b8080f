#!/bin/bash
# Pull proprietary-files.txt off a mounted copy of your own B8080-F's stock /system into
# vendor/lenovo/b8080f/proprietary, where the LineageOS build picks them up.
#
# Usage:
#   adb pull /system /tmp/b8080f-stock-system      # from the tablet's stock (or TWRP-backed-up) system
#   ./extract-files.sh /tmp/b8080f-stock-system
set -euo pipefail
SRC="${1:?usage: extract-files.sh <path to a stock /system tree>}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$HERE/../../../vendor/lenovo/b8080f/proprietary"
mkdir -p "$OUT"
missing=0
while IFS= read -r line; do
    line="${line%%#*}"; line="$(echo "$line" | xargs)"
    [ -z "$line" ] && continue
    if [ -f "$SRC/$line" ]; then
        mkdir -p "$OUT/$(dirname "$line")"
        cp -f "$SRC/$line" "$OUT/$line"
        echo "copied: $line"
    else
        echo "MISSING: $line" >&2
        missing=$((missing + 1))
    fi
done < "$HERE/proprietary-files.txt"
[ "$missing" -eq 0 ] || { echo "$missing file(s) missing from $SRC" >&2; exit 1; }
echo "Done. Blobs are in $OUT (gitignored — never commit them)."
