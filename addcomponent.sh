#!/bin/bash

# Directory where the component files are located
component_dir="./lib/output"

# Check if the directory exists
if [ ! -d "$component_dir" ]; then
    echo "Directory $component_dir not found!"
    exit 1
fi

# Find all *Component.html files in the directory
component_files=$(find "$component_dir" -type f -name "*Component.html" | sort)

# Check if there are any component files
if [ -z "$component_files" ]; then
    echo "No component files found in $component_dir"
    exit 1
fi

# Display the list of component files and prompt the user to choose one
echo "Available components:"
select component in $component_files; do
    if [ -n "$component" ]; then
        echo "You selected: $component"
        
        # Copy the selected component to the current directory
        cp "$component" ./
        
        echo "Copied $component to the current directory."
        break
    else
        echo "Invalid selection. Please choose a valid component."
    fi
done
