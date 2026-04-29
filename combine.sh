#!/usr/bin/env bash

shopt -s nullglob nocaseglob

> files.txt
for f in *-c.mp4; do
    echo "file '$f'" >> files.txt
done

if [[ ! -s files.txt ]]; then
    echo "No normalized files found. Nothing to combine."
    exit 1
fi

echo "Concatenating $(wc -l < files.txt) clips into $FINAL_OUTPUT..."

if ! ffmpeg -hide_banner -loglevel error -stats \
    -f concat -safe 0 -i "$list_file" \
    -c copy \
    "$FINAL_OUTPUT"; then

    echo "Concatenation failed!"
    exit 1
fi

echo "Success! Final video created: $FINAL_OUTPUT"
exit 0
