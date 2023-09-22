#!/bin/bash

# Function to process command-line arguments
process_args() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
        -d|--description)
        IMAGE_DESCRIPTION="$2"
        shift
        shift
        ;;
        -n|--num-images)
        NUM_IMAGES="$2"
        shift
        shift
        ;;
        -s|--size)
        IMAGE_SIZE="$2"
        shift
        shift
        ;;
        -p|--prefix)
        PREFIX="$2"
        shift
        shift
        ;;
        *)
        shift
        ;;
    esac
  done
}

# Process command-line arguments
process_args "$@"

# Shuffle all API keys from the list
API_KEYS_ARRAY=($(echo $OPENAI_API_KEYS | tr "," "\n"))
RANDOM_KEY=$(shuf -e "${API_KEYS_ARRAY[@]}" | head -n 1)

# If not provided, get user's input for image description
if [[ -z "$IMAGE_DESCRIPTION" ]]; then
  read -p "Enter a description for the image you want to generate: " IMAGE_DESCRIPTION
fi

# If a prefix is set, concatenate it with the description
if [[ ! -z "$PREFIX" ]]; then
  IMAGE_DESCRIPTION="$PREFIX $IMAGE_DESCRIPTION"
fi

# If not provided, get the number of images
if [[ -z "$NUM_IMAGES" ]]; then
  read -p "Enter the number of images you want (default is 1): " NUM_IMAGES
  if [[ -z "$NUM_IMAGES" ]]; then
    NUM_IMAGES=1
  fi
fi

# If not provided, get the size of images
if [[ -z "$IMAGE_SIZE" ]]; then
  read -p "Enter the size of the images (default is 1024x1024): " IMAGE_SIZE
  if [[ -z "$IMAGE_SIZE" ]]; then
    IMAGE_SIZE="1024x1024"
  fi
fi

# Call OpenAI API to generate the images
RESPONSE=$(curl -s "https://api.openai.com/v1/images/generations" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $RANDOM_KEY" \
  -d "{
    \"prompt\": \"$IMAGE_DESCRIPTION\",
    \"n\": $NUM_IMAGES,
    \"size\": \"$IMAGE_SIZE\"
  }")

# Extract image URLs from the response
IMAGE_URLS=($(echo "$RESPONSE" | jq -r '.data[].url'))

# Output the response in red if no URLs
if [[ -z "$IMAGE_URLS" ]]; then
    echo -e "\e[31m$RESPONSE\e[0m"
    exit 1
fi

echo "Here are the generated images:"
for IMAGE_URL in "${IMAGE_URLS[@]}"
do
    echo "$IMAGE_URL"
done

# Create markdown file
MARKDOWN_FILE="${IMAGE_DESCRIPTION// /_}.md"
echo "# $IMAGE_DESCRIPTION" > $MARKDOWN_FILE

# Embed images in markdown file
for url in "${IMAGE_URLS[@]}"; do
    echo "![]($url)" >> $MARKDOWN_FILE
done

echo "Markdown file created with the images: $MARKDOWN_FILE"
