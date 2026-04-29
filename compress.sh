#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob nocaseglob

readonly V_CODEC="libx265"
readonly CRF="23"
readonly PRESET="slow"

for pfile in *-p.mp4; do
    rm -fv "$pfile"
done

for file in *.mp4 *.mov; do
    [[ "$file" =~ -(c|p)\.mp4$ ]] && continue

    base="${file%.*}"
    pfile="${base}-p.mp4"
    cfile="${base}-c.mp4"

    [[ -f "$cfile" ]] && continue

    echo "=== Processing: $file ==="

    if ffmpeg -hide_banner -loglevel error -stats \
        -i "$file" \
        -map 0 \
        -c:v "$V_CODEC" -crf "$CRF" -preset "$PRESET" \
        -c:a aac -b:a 128k \
        -movflags +faststart \
        "$pfile"; then

        mv -f -- "$pfile" "$cfile"
        echo "Completed: $cfile"
    else
        echo "Failed: $file"
        rm -f -- "$pfile"
    fi
done
