#!/bin/bash

# Function to find the project root directory
find_project_root() {
    local dir="$(cd "${1:-$(pwd)}" && pwd)"  # Convert to absolute path
    local root_files=("README.md" "LICENSE" "CONTRIBUTE.md" "CNAME")

    while [[ "$dir" != "/" ]]; do
        for file in "${root_files[@]}"; do
            if [[ -f "$dir/$file" ]]; then
                echo "$dir"  # Return the directory as the project root
                return 0
            fi
        done
        dir=$(dirname "$dir")  # Move one level up
    done

    return 1  # Return error if no root found
}

# Get the current directory where the script is executed
current_dir=$(pwd)

# Find the project root directory (if needed for other purposes)
project_root=$(find_project_root "$(dirname "${BASH_SOURCE[0]}")")

# Check if the project root was found
if [[ -z "$project_root" ]]; then
    echo "Error: Could not find the project root."
    exit 1
fi

# Append the scripts directory to the root path
scripts_dir="$project_root/scripts"

# Check if the generate_site.sh script exists in the scripts directory
if [[ ! -f "$scripts_dir/generate_site.sh" ]]; then
    echo "Error: generate_site.sh not found in $scripts_dir"
    exit 1
fi

# Check if a theme was provided as an argument, default to empty string if none
if [[ -n "$1" ]]; then
    theme="$1"
    echo "Theme '$theme' will be used."
else
    theme="default"
    echo "No theme provided, proceeding with default theme."
fi

# Run the generate_site.sh script and pass the current directory and theme as parameters
"$scripts_dir/generate_site.sh" "$current_dir" "$theme"
