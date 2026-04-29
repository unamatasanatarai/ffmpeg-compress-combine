#!/usr/bin/env bash

shopt -s nullglob nocaseglob

echo "=== Step 2: Combining all normalized files ==="

# Create concat list (only -c.mp4 files)
> files.txt
for f in *-c.mp4; do
    echo "file '$f'" >> files.txt
done

if [[ ! -s files.txt ]]; then
    echo "No normalized files found. Nothing to combine."
    exit 1
fi

echo "Concatenating $(wc -l < files.txt) clips into $FINAL_OUTPUT..."

if ffmpeg -f concat -safe 0 -i files.txt -c copy "$FINAL_OUTPUT"; then
    echo "Success! Final video created: $FINAL_OUTPUT"
    exit 0
fi

echo "Concatenation failed!"
exit 1

