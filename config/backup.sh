#!/bin/bash

# twp-backup_*

file=$(ls ~/Downloads/twp-backup_* 2>/dev/null)

if [ -n "$file" ]; then
  mkdir -p ~/config/twp
  mv "$file" ~/config/twp/twp-backup.txt
fi

# my-ublock-static-filters_*

file=$(ls ~/Downloads/my-ublock-static-filters_* 2>/dev/null)

if [ -n "$file" ]; then
  mkdir -p ~/config/ublock
  mv "$file" ~/config/ublock/my-ublock-static-filters.txt
fi

# vimium_c-*.json

file=$(ls ~/Downloads/vimium_c-* 2>/dev/null)

if [ -n "$file" ]; then
  mkdir -p ~/config/vimium
  mv "$file" ~/config/vimium/vimium_c-backup.json
fi

trash ~/Downloads/* 2>/dev/null
