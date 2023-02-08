#!/bin/bash

file=$(ls ~/Downloads/twp-backup_* 2>/dev/null)

if [ -n "$file" ]; then
  mkdir -p ~/.config/browser/twp
  mv "$file" ~/.config/browser/twp/twp-backup.txt
fi

trash ~/Downloads/* 2>/dev/null
