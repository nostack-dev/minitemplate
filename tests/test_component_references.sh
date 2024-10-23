#!/bin/bash

# Test script for Component References Check

echo -e "\n--- Initializing test: Component References Check ---"

# Path to the components directory where the test components should be copied
components_dir="./tests"
html_files=$(find "$components_dir" -name "*.html")

# Initialize flag to track if any component is missing
component_missing=false

# Loop through each HTML file and extract component references
for file in $html_files; do
    echo -e "\n--- Checking file: $file ---"

    # Extract all component references from the file (this will match anything inside {{...}})
    component_references=$(grep -oP '{{\s*\K\w+Component(?=\s*}})' "$file")

    # Check each component reference to see if the corresponding component file exists
    for component in $component_references; do
        component_file="$components_dir/$component.html"

        if [ ! -f "$component_file" ]; then
            echo -e "${RED}✖ Missing component file: $component_file (Referenced as {{$component}}) in $file${NC}"
            component_missing=true
        else
            echo -e "${GREEN}✔ Component file found for reference: {{$component}} in $file${NC}"
        fi
    done
done

# Check if any components were missing and exit accordingly
if [ "$component_missing" = true ]; then
    echo -e "${RED}✖ Some component references are invalid. Please fix the missing component files.${NC}"
    exit 1  # Mark the test as failed
else
    echo -e "${GREEN}✔ All component references are valid.${NC}"
    exit 0  # Mark the test as passed
fi
