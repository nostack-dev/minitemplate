#!/bin/bash

# Prompt the user for a project name
read -p "Enter the project name: " project_name

# Define the base directory as ./projects
base_dir="../projects"

# Define the target project directory as ./projects/myproject
target_dir="$base_dir/$project_name"

# Define the source directory for components and template
components_dir="../components/default"
template_file="../templates/template_default.html"

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

# Check if the components and template directory exists
if [ ! -d "$components_dir" ]; then
    echo "Error: Components directory '$components_dir' does not exist."
    exit 1
fi

# Copy template.html to the target project directory
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

# Copy additional scripts to the target project directory
for script in generate_site.sh add.sh print.sh; do
    if [ -f "./$script" ]; then
        cp "./$script" "$target_dir/"
        echo "Copied $script to '$target_dir'."
    else
        echo "Warning: $script not found in root directory."
    fi
done

echo "Project setup complete!"
