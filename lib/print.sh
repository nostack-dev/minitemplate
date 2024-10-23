#!/bin/bash

# Run 'tree' on the current directory
tree

# Iterate through all root-level files in the current directory
for file in ./*; do
    # Check if it's a file (not a directory)
    if [ -f "$file" ]; then
        echo "Contents of $file:"
        cat "$file"
        echo "------------------------"
    fi
done

