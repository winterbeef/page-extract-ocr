#!/usr/bin/env bash

# Extract page numbers from JPGs using ImageMagick + Tesseract
# Without temporary files.

for f in *.jpg; do
    digits=$(magick "$f" \
        -gravity south -crop 100%x5+0+0 +repage \
        -colorspace Gray -threshold 50% - | \
        tesseract - - --psm 6 -c tessedit_char_whitelist=0123456789'(){}[] ' 2>/dev/null | \
        egrep -o '[\(\{\[][[:space:]]*[[:digit:]]+' | \
        egrep -o '[[:digit:]]+')
    if [[ -n "$digits" ]]; then
        mv -- "$f" "${digits}.jpg"
    fi
done
