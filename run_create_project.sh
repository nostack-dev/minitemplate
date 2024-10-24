#!/bin/bash

# Function to find the project root based on key files like README.md, LICENSE, etc.
find_project_root() {
    local dir="$(cd "${1:-$(pwd)}" && pwd)"  # Convert to absolute path
    local root_files=("README.md" "LICENSE" "CONTRIBUTE.md" "CNAME")

    while [[ "$dir" != "/" ]]; do
        for file in "${root_files[@]}"; do
            if [[ -f "$dir/$file" ]]; then
                echo "$dir"
                return 0
            fi
        done
        dir=$(dirname "$dir")  # Move one level up
    done

    echo "No project root found"
    return 1
}

# Find the project root
project_root=$(find_project_root)

# Check if the project root was found
if [[ -z "$project_root" ]]; then
    echo "Error: Project root not found."
    exit 1
fi

# Construct the path to the create_project.sh script
create_project_script="$project_root/scripts/create_project.sh"

# Check if create_project.sh exists
if [[ ! -f "$create_project_script" ]]; then
    echo "Error: create_project.sh not found in $project_root/scripts."
    exit 1
fi

# Execute the create_project.sh script
bash "$create_project_script"
