#!/bin/bash

# Path to the tests directory where components are copied over
components_dir="./tests"

# Find all HTML files in the tests directory
html_files=$(find ./tests -name "*.html")

echo "Scanning for invalid component references in all HTML files..."

# Initialize flag to track if any component is missing
component_missing=false

# Loop through each HTML file and extract component references
for file in $html_files; do
    echo "Checking file: $file"

    # Extract all component references from the file (this will match anything inside {{...}})
    component_references=$(grep -oP '{{\s*\K\w+Component(?=\s*}})' "$file")

    # Check each component reference to see if the corresponding component file exists
    for component in $component_references; do
        component_file="$components_dir/$component.html"

        if [ ! -f "$component_file" ]; then
            echo -e "✖ Missing component file: $component_file (Referenced as {{$component}}) in $file"
            component_missing=true
        fi
    done
done

# Check if any components were missing and exit accordingly
if [ "$component_missing" = true ]; then
    echo "Some component references are invalid. Please fix the missing component files."
    exit 1  # Mark the test as failed
else
    echo "All component references are valid."
    exit 0  # Mark the test as passed
fi
