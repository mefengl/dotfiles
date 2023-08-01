#!/bin/bash

# Define whisper function
whisper() {
    # green echo
    echo -e "\e[32m$2\e[0m"

    OUTPUT_FILE="${1%.*}.txt"
    ATTEMPTS=0
    MAX_RETRIES=5
    API_KEY=$2

    # Write the video title and URL to the output file
    echo "Video Title: ${VIDEO_TITLE}" >"$OUTPUT_FILE"
    echo "Video URL: ${YT_URL}" >>"$OUTPUT_FILE"
    echo "" >>"$OUTPUT_FILE"

    while [ $ATTEMPTS -lt $MAX_RETRIES ]; do
        curl "https://api.openai.com/v1/audio/transcriptions" \
            -H "Authorization: Bearer $API_KEY" \
            -H "Content-Type: multipart/form-data" \
            -F "model=whisper-1" \
            -F "response_format=text" \
            -F "file=@$1" >>"$OUTPUT_FILE"
        if [ $? -eq 0 ]; then
            break
        else
            let ATTEMPTS=ATTEMPTS+1
            echo "Curl failed. Attempt: $ATTEMPTS"
            rm -f "$OUTPUT_FILE"
        fi
    done
    # Add article divider
    echo "" >>"$OUTPUT_FILE"
    echo "--- article divider ---" >> "$OUTPUT_FILE"
    rm -f "$1"
}

# Define wait_for_jobs function
wait_for_jobs() {
    local max_jobs=$1
    while true; do
        local current_jobs=$(jobs -p | wc -l)
        if ((current_jobs < max_jobs)); then
            break
        fi
        sleep 1
    done
}

# Input parameters
YT_URL=$1

# Today's date
TODAY=$(date '+%Y%m%d')

# Extract the video title and publish date with yt-dlp
VIDEO_TITLE=$(yt-dlp --get-title $YT_URL | sed 's/[^a-zA-Z0-9]//g') # Removing non-alphanumeric characters
PUBLISH_DATE=$(yt-dlp --get-filename -o "%(upload_date)s" $YT_URL)

DIR=~/Downloads/${TODAY}
mkdir -p "$DIR" && cd "$DIR"

yt-dlp --external-downloader aria2c --external-downloader-args "-x16 -s16 -k2M" -x --audio-format wav -o "${PUBLISH_DATE}_${VIDEO_TITLE}.wav" $YT_URL

# File processing
INPUT_FILE="${PUBLISH_DATE}_${VIDEO_TITLE}.wav"
FILE_EXT="${INPUT_FILE##*.}"
FILE_NAME="${INPUT_FILE%.*}"
COUNT=0
SEGMENT_TIME=1200

OUTPUT_FILE="${FILE_NAME}.txt"
rm -f "$OUTPUT_FILE"

if [[ $FILE_EXT != "wav" ]]; then
    ffmpeg -y -i "$INPUT_FILE" "$FILE_NAME.wav"
fi

ffmpeg -i "$FILE_NAME.wav" -f segment -segment_time $SEGMENT_TIME -acodec mp3 "${FILE_NAME}_segment%03d.mp3"

# Select 3 random API keys from the list
API_KEYS_ARRAY=($(echo $OPENAI_API_KEYS | tr "," "\n"))
shuffled_keys=($(shuf -e "${API_KEYS_ARRAY[@]}"))
selected_keys=("${shuffled_keys[@]:0:3}")

# Iterate over each segment file and pass it to the whisper function
i=0
for segment in "${FILE_NAME}_segment"*."mp3"; do
    echo "Processing $segment"
    ((COUNT++))
    whisper $segment ${selected_keys[$i]} &
    ((i = (i + 1) % 3))
    wait_for_jobs 9
done

wait

echo "Processed $COUNT files."
