#!/bin/bash

file=$(ls ~/Downloads/twp-backup_* 2>/dev/null)

if [ -n "$file" ]; then
  mkdir -p ~/config/twp
  mv "$file" ~/config/twp/twp-backup.txt
fi

# my-ublock-static-filters_2023-02-20_15.53.49

file=$(ls ~/Downloads/my-ublock-static-filters_* 2>/dev/null)

if [ -n "$file" ]; then
  mkdir -p ~/config/ublock
  mv "$file" ~/config/ublock/my-ublock-static-filters.txt
fi

trash ~/Downloads/* 2>/dev/null
