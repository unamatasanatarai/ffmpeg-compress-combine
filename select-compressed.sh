#!/usr/bin/env bash

mkdir -p "compressed"

for f in *-c.mp4; do
    mv -v "$f" "compressed/$f"
done
