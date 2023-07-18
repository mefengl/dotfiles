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
}

# Input parameters
INPUT_FILE=$1

# File processing
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
done

# Wait for all background tasks to finish
wait

echo "Processed $COUNT files."

# Ask user if they want to run "cat *.txt | pbcopy"
read -p "Do you want to copy the contents of all text files to clipboard? (y/n): " answer
if [[ $answer = y ]]; then
	cat *.txt | pbcopy
	echo "Contents of all text files have been copied to the clipboard."
fi
