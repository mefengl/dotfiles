#!/bin/bash

file=$(ls ~/Downloads/twp-backup_* 2>/dev/null)

if [ -n "$file" ]; then
  mkdir -p ~/config/twp
  mv "$file" ~/config/twp/twp-backup.txt
fi

trash ~/Downloads/* 2>/dev/null
