#!/usr/bin/env bash

shopt -s nullglob nocaseglob

# Remove incomplete files
for pfile in *-p.mp4; do
    rm -fv "$pfile"
done

for file in *.mp4 *.mov; do
    # Skip already processed files
    [[ "$file" =~ -c\.mp4$ ]] && continue
    [[ "$file" =~ -p\.mp4$ ]] && continue

    base="${file%.*}"

    pfile="${base}-p.mp4"
    cfile="${base}-c.mp4"

    [[ -f "$cfile" ]] && continue

    echo "=== Processing: $file ==="

    if ffmpeg -i "$file" \
        -c:v libx265 \
        -crf 23 \
        -preset slow \
        -c:a aac \
        -b:a 128k \
        "$pfile"; then

        mv "$pfile" "$cfile"
        echo "Completed: $cfile"
    else
        echo "Failed: $file"
        rm -f "$pfile"
    fi
done
