#!/bin/bash

# Function to find the project root directory
find_project_root() {
    local dir="$(cd "${1:-$(pwd)}" && pwd)"
    local root_files=("README.md" "LICENSE" "CONTRIBUTE.md" "CNAME")

    while [[ "$dir" != "/" ]]; do
        for file in "${root_files[@]}"; do
            if [[ -f "$dir/$file" ]]; then
                echo "$dir"
                return 0
            fi
        done
        dir=$(dirname "$dir")
    done

    return 1
}

# Determine project root
project_root=$(find_project_root "$(dirname "${BASH_SOURCE[0]}")")
if [[ -z "$project_root" ]]; then
    echo "Error: Could not find the project root."
    exit 1
fi

# Set the components and instantiable directories based on project root
components_dir="$project_root/components/converted"
instantiable_dir="$components_dir/instantiable"

# Create the instantiable directory if it does not exist
mkdir -p "$instantiable_dir"

# Iterate over each HTML file in the components directory
for file in "$components_dir"/*.html; do
    # Extract the base filename (e.g., button from button.html)
    component_name=$(basename "$file" .html)
    instance_id="component_${component_name}_instance"

    # Define the output filename with "_instance" suffix
    output_filename="${component_name}_instance.html"

    # Wrap content in a <template> tag with the unique ID
    wrapped_content=$(sed "1s/^/<template id=\"$instance_id\">\n/" "$file" | sed "$ a </template>")

    # Save the wrapped content to the instantiable folder with the new filename
    echo "$wrapped_content" > "$instantiable_dir/$output_filename"
done

echo "Wrapped components created in $instantiable_dir with '_instance' suffix."
