#!/bin/bash

# Shuffle all API keys from the list
API_KEYS_ARRAY=($(echo $OPENAI_API_KEYS | tr "," "\n"))
RANDOM_KEY=$(shuf -e "${API_KEYS_ARRAY[@]}" | head -n 1)

# Get user's input for image description
read -p "Enter a description for the image you want to generate: " IMAGE_DESCRIPTION

# Get the number of images
read -p "Enter the number of images you want (default is 1): " NUM_IMAGES
if [[ -z "$NUM_IMAGES" ]]; then
    NUM_IMAGES=1
fi

# Get the size of images
read -p "Enter the size of the images (default is 1024x1024): " IMAGE_SIZE
if [[ -z "$IMAGE_SIZE" ]]; then
    IMAGE_SIZE="1024x1024"
fi

# Call OpenAI API to generate the images using the randomly chosen key
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

# Create markdown file
MARKDOWN_FILE="${IMAGE_DESCRIPTION// /_}.md"
echo "# $IMAGE_DESCRIPTION" > $MARKDOWN_FILE

# Embed images in markdown file
for url in "${IMAGE_URLS[@]}"; do
    echo "![]($url)" >> $MARKDOWN_FILE
done

echo "Markdown file created with the images: $MARKDOWN_FILE"
