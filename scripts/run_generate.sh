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

# Find the project root directory
project_root=$(find_project_root "$(dirname "${BASH_SOURCE[0]}")")

# Check if the project root was found
if [[ -z "$project_root" ]]; then
    echo "Error: Could not find the project root."
    exit 1
fi

# Append the scripts directory to the root path
scripts_dir="$project_root/scripts"

# Print the final scripts directory for verification
echo "Scripts directory path: $scripts_dir"

# Check if the generate_site.sh script exists in the scripts directory
if [[ ! -f "$scripts_dir/generate_site.sh" ]]; then
    echo "Error: generate_site.sh not found in $scripts_dir"
    exit 1
fi

# Check if a theme was provided as an argument, default to empty string if none
if [[ -n "$2" ]]; then
    theme="$2"
else
    theme="default"
    echo "No theme provided, proceeding with default theme."
fi

# Run the generate_site.sh script and pass the project directory and theme as parameters
"$scripts_dir/generate_site.sh" "$1" "$theme"
