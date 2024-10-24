#!/bin/bash

# Find the project root
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

# Get the project root dynamically
project_root=$(find_project_root)

if [[ -z "$project_root" ]]; then
    echo "Error: Project root not found."
    exit 1
fi

# Prompt the user for a project name
read -p "Enter the project name: " project_name

# Define the base directory as ./projects inside the project root
base_dir="$project_root/projects"

# Define the target project directory
target_dir="$base_dir/$project_name"

# Define the source directory for components and template
components_dir="$project_root/components/default"
template_file="$project_root/templates/template_default.html"
scripts_dir="$project_root/scripts"

# Check if the base projects directory exists, if not create it
if [ ! -d "$base_dir" ]; then
    echo "Creating base directory '$base_dir'..."
    mkdir -p "$base_dir"
fi

# Check if the project directory already exists
if [ -d "$target_dir" ]; then
    echo "Error: Directory '$target_dir' already exists. Exiting."
    exit 1
else
    # Create the project directory
    mkdir -p "$target_dir"
    echo "Directory '$target_dir' created successfully."
fi

# Check if the components directory exists
if [ ! -d "$components_dir" ]; then
    echo "Error: Components directory '$components_dir' does not exist."
    exit 1
fi

# Copy template_default.html to the target project directory
if [ -f "$template_file" ]; then
    cp "$template_file" "$target_dir/"
    echo "Copied template_default.html to '$target_dir'."
else
    echo "Error: template_default.html not found in '$template_file'."
    exit 1
fi

# Copy all components from the components directory to the target project directory
cp "$components_dir"/* "$target_dir/"
echo "Copied all default components to '$target_dir'."

# Copy run_generate.sh to the project directory
run_generate_script="$scripts_dir/run_generate.sh"
if [ -f "$run_generate_script" ]; then
    cp "$run_generate_script" "$target_dir/"
    echo "Copied run_generate.sh to '$target_dir'."
else
    echo "Error: run_generate.sh not found in '$scripts_dir'."
fi


# Copy run_add.sh to the project directory
run_add_script="$scripts_dir/run_add.sh"
if [ -f "$run_add_script" ]; then
    cp "$run_add_script" "$target_dir/"
    echo "Copied run_add.sh to '$target_dir'."
else
    echo "Error: run_add.sh not found in '$scripts_dir'."
fi
echo "Project setup complete!"
