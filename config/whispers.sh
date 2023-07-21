#!/bin/bash

# Check if an argument was provided. If so, use that as input.
if [ $# -eq 0 ]; then
    echo "Please enter the string of URLs (press Ctrl-D when done):"
    URLS_STRING=""
    while IFS= read -r line; do
        URLS_STRING+="$line "
    done
else
    URLS_STRING="$1"
fi

# Extract URLs, remove duplicates, and pass them to whisper.sh using xargs
echo "$URLS_STRING" | awk -v RS='[ ,]+' '/^https:\/\/www.youtube.com\// {print}' | sort | uniq | xargs -P 9 -I{} bash ~/config/whisper.sh "{}"
