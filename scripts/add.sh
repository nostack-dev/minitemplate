#!/bin/bash

find_project_root() {
    local dir="$(cd "${1:-$(pwd)}" && pwd)"  # Convert to absolute path
    local root_files=("README.md" "LICENSE" "CONTRIBUTE.md" "CNAME")

    while [[ "$dir" != "/" ]]; do
        echo "Checking directory: $dir"  # Print current directory

        for file in "${root_files[@]}"; do
            if [[ -f "$dir/$file" ]]; then
                echo "Project root found at: $dir"
                return 0
            fi
        done

        dir=$(dirname "$dir")  # Move one level up
    done

    echo "No project root found"
    return 1
}

# Example usage
find_project_root "$(dirname "${BASH_SOURCE[0]}")"

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define directories based on the script's directory
project_root="$(dirname "$SCRIPT_DIR")"  # Get the project root directory
default_dir="$project_root/components/default"
converted_dir="$project_root/components/converted"
custom_dir="$project_root/components/custom"
templates_dir="$project_root/templates"

# Check if the default components directory exists
if [ ! -d "$default_dir" ]; then
    echo "Error: Directory $default_dir not found!"
    exit 1
fi

# Gather component lists
converted_components=($(find "$converted_dir" -type f -name "*.html" | sed 's|.*/||' | sed 's/.html//'))
custom_components=($(find "$custom_dir" -type f -name "*.html" | sed 's|.*/||' | sed 's/.html//'))
default_components=($(find "$default_dir" -type f -name "*.html" | sed 's|.*/||'))

# Gather template list
template_files=($(find "$templates_dir" -type f -name "*.html" | sed 's|.*/||'))

# Function to display components in a side-by-side format
display_components() {
    local title="$1"
    shift
    local components=("$@")

    printf "\n$title:\n"
    if [ ${#components[@]} -eq 0 ]; then
        echo "No components found!"
    else
        for ((i=0; i<${#components[@]}; i+=3)); do
            printf "%-30s %-30s %-30s\n" "${components[i]:-}" "${components[i+1]:-}" "${components[i+2]:-}"
        done
    fi
}

# Check if a component name is passed as a parameter
if [ -z "$1" ]; then
    display_components "Available components (Converted)" "${converted_components[@]}"
    display_components "Available components (Custom)" "${custom_components[@]}"
    display_components "Available components (Default)" "${default_components[@]}"
    display_components "Available templates" "${template_files[@]}"

    # Display usage at the end
    echo -e "\nUsage: ./run_add.sh [defaults|component|template]"
    echo "Example: ./run_add.sh defaults or ./run_add.sh button or ./run_add.sh template_default.html"
    exit 1
fi

# Handle defaults parameter
if [ "$1" == "defaults" ]; then
    echo -e "\n--- Copying Default Components ---"
    for file in "$default_dir"/*.html; do
        filename=$(basename "$file")

        # Check if the file already exists in the current directory
        if [ -f "$filename" ]; then
            read -p "$filename already exists. Override? (y/n): " choice
            if [[ "$choice" != [Yy] ]]; then
                echo "Skipping $filename."
                continue
            fi
        fi

        cp "$file" ./
        echo "Copied $filename to the current directory."
    done

    echo -e "\n--- Copying Default Template ---"
    template_file="$templates_dir/template_default.html"

    if [ -f "$template_file" ]; then
        # Check if the template file already exists in the current directory
        if [ -f "template_default.html" ]; then
            read -p "template_default.html already exists. Override? (y/n): " choice
            if [[ "$choice" != [Yy] ]]; then
                echo "Skipping template_default.html."
            else
                cp "$template_file" ./
                echo "Copied template_default.html to the current directory."
            fi
        else
            cp "$template_file" ./
            echo "Copied template_default.html to the current directory."
        fi
    else
        echo "Warning: template_default.html not found in the templates directory."
    fi

    exit 0
fi

# Check if the argument is a template
if [[ " ${template_files[*]} " == *" $1 "* ]]; then
    template_file="$templates_dir/$1"

    # Check if the template file already exists in the current directory
    if [ -f "$1" ]; then
        read -p "$1 already exists. Override? (y/n): " choice
        if [[ "$choice" != [Yy] ]]; then
            echo "Skipping $1."
            exit 0
        fi
    fi

    cp "$template_file" ./
    echo "Copied template: $template_file to the current directory."
    exit 0
fi

# Determine if the component is custom
if [[ "$1" == *custom ]]; then
    component="$custom_dir/${1}.html"
else
    component="$converted_dir/${1}.html"
fi

# Check if the component file exists
if [ -f "$component" ]; then
    echo "You selected: $component"

    # Check if the component file already exists in the current directory
    if [ -f "${1}.html" ]; then
        read -p "${1}.html already exists. Override? (y/n): " choice
        if [[ "$choice" != [Yy] ]]; then
            echo "Skipping ${1}.html."
            exit 0
        fi
    fi

    cp "$component" ./
    echo "Copied $component to the current directory."
else
    echo "Component '$1' not found!"
    exit 1
fi
