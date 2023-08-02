#!/bin/bash

whisper() {
	echo -e "\e[32m$2\e[0m"
	OUTPUT_FILE="${1%.*}.txt"
	ATTEMPTS=0
	MAX_RETRIES=5
	API_KEY=$2

	echo "Video Title: ${VIDEO_TITLE}" >"$OUTPUT_FILE"
	echo "Video URL: ${YT_URL}" >>"$OUTPUT_FILE"
	echo "" >>"$OUTPUT_FILE"

	while [ $ATTEMPTS -lt $MAX_RETRIES ]; do
		RESPONSE=$(curl -s -w "%{http_code}" "https://api.openai.com/v1/audio/transcriptions" \
			-H "Authorization: Bearer $API_KEY" \
			-H "Content-Type: multipart/form-data" \
			-F "model=whisper-1" \
			-F "response_format=text" \
			-F "file=@$1")
		HTTP_CODE=${RESPONSE:(-3)}
		API_RESPONSE=${RESPONSE:0:${#RESPONSE}-3}

		if [[ $HTTP_CODE -eq 429 ]]; then
			let ATTEMPTS=ATTEMPTS+1
			echo "API quota exceeded. Attempt: $ATTEMPTS"
			sleep 5
		else
			echo "$API_RESPONSE" >>"$OUTPUT_FILE"
			break
		fi
	done

	echo "" >>"$OUTPUT_FILE"
	echo "--- article divider ---" >>"$OUTPUT_FILE"
	rm -f "$1"
}

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

INPUT_FILE=$1
YT_URL="Downloaded File - No URL"
VIDEO_TITLE="${INPUT_FILE%.*}"

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

API_KEYS_ARRAY=($(echo $OPENAI_API_KEYS | tr "," "\n"))
shuffled_keys=($(shuf -e "${API_KEYS_ARRAY[@]}"))
selected_keys=("${shuffled_keys[@]:0:3}")

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
