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
converted_templates_dir="$converted_dir/instantiable"  # Directory for instanciable <template/> components

# Check if the default components directory exists
if [ ! -d "$default_dir" ]; then
    echo "Error: Directory $default_dir not found!"
    exit 1
fi

# Gather component lists
converted_components=($(find "$converted_dir" -maxdepth 1 -type f -name "*.html" | sed 's|.*/||' | sed 's/.html//'))
custom_components=($(find "$custom_dir" -type f -name "*.html" | sed 's|.*/||' | sed 's/.html//'))
default_components=($(find "$default_dir" -type f -name "*.html" | sed 's|.*/||'))
template_files=($(find "$templates_dir" -type f -name "*.html" | sed 's|.*/||'))
converted_template_components=($(find "$converted_templates_dir" -type f -name "*_instance.html" | sed 's|.*/||' | sed 's/.html//'))

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
override_all=false
for arg in "$@"; do
    if [[ "$arg" == "--override-all" ]]; then
        override_all=true
        break
    fi
done

if [ -z "$1" ] && ! $override_all; then
    display_components "Available components (Converted)" "${converted_components[@]}"
    display_components "Available components (Custom)" "${custom_components[@]}"
    display_components "Available components (Default)" "${default_components[@]}"
    display_components "Available templates" "${template_files[@]}"
    display_components "Available template components (Converted Instances)" "${converted_template_components[@]}"

    # Display usage at the end
    echo -e "\nUsage: ./run_add.sh [defaults|all|component|template|template component] [--override-all]"
    echo "Example: ./run_add.sh defaults or ./run_add.sh all or ./run_add.sh button or ./run_add.sh template_default.html or ./run_add.sh accordion_instance"
    exit 1
fi

# Handle all parameter
if [ "$1" == "all" ]; then
    echo -e "\n--- Copying All Converted Template Components and Non-Instance Components ---"

    # Copy all non-instantiable components from the converted directory
    for file in "$converted_dir"/*.html; do
        filename=$(basename "$file")

        # Check if the file already exists in the current directory
        if [ -f "$filename" ]; then
            if ! $override_all; then
                read -p "$filename already exists. Override? (y/n): " choice
                if [[ "$choice" != [Yy] ]]; then
                    echo "Skipping $filename."
                    continue
                fi
            fi
        fi

        cp "$file" ./  # Copy each file to the current directory
        echo "Copied $filename to the current directory."
    done

    # Now copy all instantiable template components
    for file in "$converted_templates_dir"/*.html; do
        filename=$(basename "$file")

        # Check if the file already exists in the current directory
        if [ -f "$filename" ]; then
            if ! $override_all; then
                read -p "$filename already exists. Override? (y/n): " choice
                if [[ "$choice" != [Yy] ]]; then
                    echo "Skipping $filename."
                    continue
                fi
            fi
        fi

        cp "$file" ./  # Copy each file to the current directory
        echo "Copied $filename to the current directory."
    done

    exit 0
fi

# (The rest of your script remains unchanged)

# Handle defaults parameter
if [ "$1" == "defaults" ]; then
    echo -e "\n--- Copying Default Components ---"
    for file in "$default_dir"/*.html; do
        filename=$(basename "$file")

        # Check if the file already exists in the current directory
        if [ -f "$filename" ]; then
            if ! $override_all; then
                read -p "$filename already exists. Override? (y/n): " choice
                if [[ "$choice" != [Yy] ]]; then
                    echo "Skipping $filename."
                    continue
                fi
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
            if ! $override_all; then
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
        if ! $override_all; then
            read -p "$1 already exists. Override? (y/n): " choice
            if [[ "$choice" != [Yy] ]]; then
                echo "Skipping $1."
                exit 0
            fi
        fi
    fi

    cp "$template_file" ./ 
    echo "Copied template: $template_file to the current directory."
    exit 0
fi

# Check if the argument is a converted template component
if [[ " ${converted_template_components[*]} " == *" $1 "* ]]; then
    template_component="$converted_templates_dir/${1}.html"

    # Check if the component file already exists in the current directory
    if [ -f "${1}.html" ]; then
        if ! $override_all; then
            read -p "${1}.html already exists. Override? (y/n): " choice
            if [[ "$choice" != [Yy] ]]; then
                echo "Skipping ${1}.html."
                exit 0
            fi
        fi
    fi

    cp "$template_component" ./ 
    echo "Copied template component: $template_component to the current directory."
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
        if ! $override_all; then
            read -p "${1}.html already exists. Override? (y/n): " choice
            if [[ "$choice" != [Yy] ]]; then
                echo "Skipping ${1}.html."
                exit 0
            fi
        fi
    fi

    cp "$component" ./ 
    echo "Copied $component to the current directory."
else
    echo "Component '$1' not found!"
    exit 1
fi
