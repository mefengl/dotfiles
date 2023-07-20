#!/bin/bash

# Define whisper function
whisper() {
	OUTPUT_FILE="${1%.*}.txt"
	ATTEMPTS=0
	MAX_RETRIES=5

	while [ $ATTEMPTS -lt $MAX_RETRIES ]; do
		curl "https://api.openai.com/v1/audio/transcriptions" \
			-H "Authorization: Bearer $OPENAI_API_KEY" \
			-H "Content-Type: multipart/form-data" \
			-F "model=whisper-1" \
			-F "response_format=text" \
			-F "file=@$1" >"$OUTPUT_FILE"
		# Check if curl was successful
		if [ $? -eq 0 ]; then
			break
		else
			let ATTEMPTS=ATTEMPTS+1
			echo "Curl failed. Attempt: $ATTEMPTS"
			# Removing output file if curl failed
			rm -f "$OUTPUT_FILE"
		fi
	done
	# Delete the processed segment
	rm -f "$1"
}

# Define wait_for_jobs function
wait_for_jobs() {
	local max_jobs=$1
	while true; do
		# Get current number of background jobs
		local current_jobs=$(jobs -p | wc -l)
		# If it's less than max_jobs, break and continue processing
		if ((current_jobs < max_jobs)); then
			break
		fi
		sleep 1 # delay to avoid overloading the system
	done
}

# Input parameters
YT_URL=$1
DIR=~/Downloads/$(date '+%Y%m%d/%H%M%S')
mkdir -p "$DIR" && cd "$DIR"
yt-dlp --external-downloader aria2c --external-downloader-args "-x16 -s16 -k2M" -x --audio-format wav -o 'del.wav' $YT_URL

# File processing
INPUT_FILE="del.wav"
FILE_EXT="${INPUT_FILE##*.}"
FILE_NAME="${INPUT_FILE%.*}"
COUNT=0
SEGMENT_TIME=1200 # 20 minutes

# Clear the output file if it exists
OUTPUT_FILE="${FILE_NAME}.txt"
rm -f "$OUTPUT_FILE"

# If not wav, convert to wav
if [[ $FILE_EXT != "wav" ]]; then
	ffmpeg -y -i "$INPUT_FILE" "$FILE_NAME.wav"
fi

# Break the file into chunks
ffmpeg -i "$FILE_NAME.wav" -f segment -segment_time $SEGMENT_TIME -acodec mp3 "${FILE_NAME}_segment%03d.mp3"

# Iterate over each segment file and pass it to the whisper function
for segment in "${FILE_NAME}_segment"*."mp3"; do
	echo "Processing $segment"
	((COUNT++))
	# Call whisper function here
	whisper $segment &
	wait_for_jobs 3 # wait if there are 3 or more jobs
done

# Wait for all background tasks to finish
wait

# Remove all files
rm -f "${FILE_NAME}"*.*

echo "Processed $COUNT files."
