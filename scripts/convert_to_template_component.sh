#!/bin/bash

# Function to find the project root directory
find_project_root() {
    local dir="$(cd "${1:-$(pwd)}" && pwd)"  # Convert to absolute path
    local root_files=("README.md" "LICENSE" "CONTRIBUTE.md" "CNAME")

    while [[ "$dir" != "/" ]]; do
        for file in "${root_files[@]}"; do
            if [[ -f "$dir/$file" ]]; then
                echo "$dir"  # Only output the project root path
                return 0
            fi
        done
        dir=$(dirname "$dir")  # Move one level up
    done

    return 1  # Return error if no project root is found
}

# Determine project root
project_root=$(find_project_root "$(dirname "${BASH_SOURCE[0]}")")
if [[ -z "$project_root" ]]; then
    echo "Error: Could not find the project root."
    exit 1
fi

# Set the components and templates directories based on project root
components_dir="$project_root/components/converted"
templates_dir="$components_dir/templates"

# Create the templates directory if it does not exist
mkdir -p "$templates_dir"

# Iterate over each HTML file in the components directory
for file in "$components_dir"/*.html; do
    # Extract the base filename (e.g., button from button.html)
    component_name=$(basename "$file" .html)
    
    # Wrap content in a <template> tag with an ID based on the component name
    wrapped_content=$(sed "1s/^/<template id=\"$component_name\">\n/" "$file" | sed "$ a </template>")

    # Save the wrapped content to the templates folder
    echo "$wrapped_content" > "$templates_dir/$component_name.html"
done

echo "Wrapped components created in $templates_dir."
