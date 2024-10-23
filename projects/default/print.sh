#!/bin/bash

# Define ignore list (folders and files to ignore)
IGNORE_LIST=(
    ".git"
    ".DS_Store"
    "node_modules"
    "dist"
    "*.log"
    "README.md"
    "LICENSE"
    "CNAME"
    "CONTRIBUTING.md"
    "./lib/components_converted"
    "./tests/*/" # Ignore all subfolders of ./tests
    "./projects" # Ignore projects folder and its content
)

# Function to check if a file or folder is in the ignore list
should_ignore() {
    for ignore in "${IGNORE_LIST[@]}"; do
        if [[ "$1" == $ignore || "$1" == *$ignore ]]; then
            return 0 # Found in the ignore list, should ignore
        fi
    done
    return 1 # Not in the ignore list, should not ignore
}

# Recursive function to print directory contents
print_directory_contents() {
    local dir="$1"

    # Print the tree view of the directory
    echo "Contents of $dir:"
    tree -a "$dir" --prune --noreport

    # Recursively iterate through the files and subfolders
    for file in "$dir"/* "$dir"/.*; do
        # Skip current and parent directory entries
        if [[ "$file" == "$dir/." || "$file" == "$dir/.." ]]; then
            continue
        fi

        # Check if the file/folder is in the ignore list
        relative_file="${file#./}"  # Remove leading ./ for cleaner output
        if should_ignore "$relative_file"; then
            echo "Ignoring: $relative_file"
            continue
        fi

        # If it's a directory, call the function recursively
        if [ -d "$file" ]; then
            print_directory_contents "$file"
        elif [ -f "$file" ]; then
            # If it's a file, print its contents
            echo "Contents of $file:"
            cat "$file"
            echo "------------------------"
        fi
    done
}

# Start from the current directory
print_directory_contents "."

