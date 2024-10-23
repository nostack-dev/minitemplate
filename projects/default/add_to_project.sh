#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define directories based on the script's directory
default_dir="$SCRIPT_DIR/lib/components_default"
converted_dir="$SCRIPT_DIR/lib/components_converted"
custom_dir="$SCRIPT_DIR/lib/components_custom"
templates_dir="$SCRIPT_DIR/lib/templates"

# Check if the default components directory exists
if [ ! -d "$default_dir" ]; then
    echo "Error: Directory $default_dir not found!"
    exit 1
fi

# Gather component lists
converted_components=($(find "$converted_dir" -type f -name "*Component.html" | sed 's|.*/||' | sed 's/Component.html//'))
custom_components=($(find "$custom_dir" -type f -name "*Component.html" | sed 's|.*/||' | sed 's/Component.html//'))
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
    echo -e "\nUsage: ./add_to_project.sh [defaults|componentName|templateName]"
    echo "Example: ./add_to_project.sh defaults or ./add_to_project.sh button or ./add_to_project.sh templateName"
    exit 1
fi

# Handle defaults parameter
if [ "$1" == "defaults" ]; then
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
    component="$custom_dir/$1Component.html"
else
    component="$converted_dir/$1Component.html"
fi

# Check if the component file exists
if [ -f "$component" ]; then
    echo "You selected: $component"

    # Check if the component file already exists in the current directory
    if [ -f "$1Component.html" ]; then
        read -p "$1Component.html already exists. Override? (y/n): " choice
        if [[ "$choice" != [Yy] ]]; then
            echo "Skipping $1Component.html."
            exit 0
        fi
    fi

    cp "$component" ./
    echo "Copied $component to the current directory."
else
    echo "Component '$1' not found!"
    exit 1
fi
