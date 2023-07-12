#!/bin/bash

# Output file
output="all_readmes.md"

# Empty or create the file
echo "" > $output

# Find and append all README.md files to the output
find . -name "README.md" -type f -exec sh -c '
    for file do
        echo "// $file" >> '"$output"'
        echo "" >> '"$output"'
        cat "$file" >> '"$output"'
        echo "" >> '"$output"'
    done' sh {} +

# Print completion message
echo "All READMEs have been compiled into $output"

