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

# Check if the project name is provided as an argument
if [[ -n "$1" ]]; then
    project_name="$1"
else
    echo "Please provide a project name: ./create_project.sh myproject [theme] [base_directory]"
    exit 1
fi

# Use the second argument as the theme, or default to 'default'
if [[ -n "$2" ]]; then
    theme="$2"
else
    theme="default"
fi

# Use the third argument as the base directory if provided, otherwise default to the 'projects' directory
if [[ -n "$3" ]]; then
    base_dir="$3"
else
    base_dir="$project_root/projects"
fi

# Define the target project directory
target_dir="$base_dir/$project_name"

# Ensure the base directory is created if it doesn't exist
if [[ ! -d "$base_dir" ]]; then
    echo "Creating base directory '$base_dir'..."
    mkdir -p "$base_dir"
fi

# Create the project directory if it doesn't already exist
if [[ -d "$target_dir" ]]; then
    echo "Error: Directory '$target_dir' already exists. Exiting."
    exit 1
else
    echo "Creating project directory '$target_dir'..."
    mkdir -p "$target_dir"
fi

# Define the source directory for components and templates
components_dir="$project_root/components/default"
template_file="$project_root/templates/template_default.html"
scripts_dir="$project_root/scripts"

# Copy template_default.html to the target project directory
if [[ -f "$template_file" ]]; then
    cp "$template_file" "$target_dir/"
    echo "Copied template_default.html to '$target_dir'."
else
    echo "Error: template_default.html not found in '$template_file'."
    exit 1
fi

# Copy all components from the components directory to the target project directory
if [[ -d "$components_dir" ]]; then
    cp "$components_dir"/* "$target_dir/"
    echo "Copied all default components to '$target_dir'."
else
    echo "Error: Components directory '$components_dir' does not exist."
    exit 1
fi

# Copy run_generate.sh to the project directory
run_generate_script="$scripts_dir/run_generate.sh"
if [[ -f "$run_generate_script" ]]; then
    cp "$run_generate_script" "$target_dir/"
    echo "Copied run_generate.sh to '$target_dir'."
else
    echo "Error: run_generate.sh not found in '$scripts_dir'."
fi

# Copy run_add.sh to the project directory
run_add_script="$scripts_dir/run_add.sh"
if [[ -f "$run_add_script" ]]; then
    cp "$run_add_script" "$target_dir/"
    echo "Copied run_add.sh to '$target_dir'."
else
    echo "Error: run_add.sh not found in '$scripts_dir'."
fi

# Apply the theme (this is a placeholder, you can customize how to handle theme selection)
echo "Setting theme to '$theme' in project..."

# You can add logic here to insert the theme into the generated files

echo "Project setup complete with theme '$theme' in directory '$base_dir/$project_name'."
