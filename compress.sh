#!/usr/bin/env bash

shopt -s nullglob nocaseglob

readonly v_codec='libx265'
readonly crf='23'
readonly preset='slow'

readonly scale_filter='scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2'

for pfile in *-p.mp4; do
    if [[ -f $pfile ]]; then
        rm -f -- "$pfile"

        if [[ $? -ne 0 ]]; then
            printf 'Failed to remove temporary file: %s\n' "$pfile" >&2
            exit 1
        fi
    fi
done

for file in *.mp4 *.mov; do
    [[ -f $file ]] || continue

    case $file in
        *-c.mp4|*-p.mp4)
            continue
        ;;
    esac

    base=${file%.*}
    pfile=${base}-p.mp4
    cfile=${base}-c.mp4

    [[ -f $cfile ]] && continue

    printf 'Processing: %s\n' "$file"

    ffmpeg \
        -hide_banner \
        -loglevel error \
        -stats \
        -i "$file" \
        -map 0 \
        -vf "$scale_filter" \
        -c:v "$v_codec" \
        -crf "$crf" \
        -preset "$preset" \
        -c:a aac \
        -b:a 128k \
        -movflags +faststart \
        -- \
        "$pfile"

    if [[ $? -eq 0 ]]; then
        mv -f -- "$pfile" "$cfile"

        if [[ $? -ne 0 ]]; then
            printf 'Failed to finalize output: %s\n' "$cfile" >&2
            rm -f -- "$pfile"
            exit 2
        fi

        printf 'Completed: %s\n' "$cfile"
    else
        printf 'Failed: %s\n' "$file" >&2

        if [[ -f $pfile ]]; then
            rm -f -- "$pfile"
        fi
    fi
done

