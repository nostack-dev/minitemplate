#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the template and output files
TEMPLATE_FILE="./lib/templates/default.html"  # Default template file
OUTPUT_FILE="index.html"                      # Output file set to index.html

# Optional template parameter
if [[ ! -z "$1" ]]; then
    if [[ "$1" == "showcase" ]]; then
        TEMPLATE_FILE="./lib/showcase.html"
        OUTPUT_FILE="./lib/showcase_output.html"  # Showcase output file
        echo "Showcase mode enabled. Processing 'showcase.html' in ./lib/."
    else
        TEMPLATE_FILE="$1"  # Use user-provided template
        echo "Using template: $TEMPLATE_FILE"
    fi
fi

# Check if the specified template file exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found."
    exit 1
fi

# Function to ensure all required components exist
ensure_components() {
    for component in sidebarComponent.html contentComponent.html footerComponent.html; do
        if [[ ! -f "$component" ]]; then
            echo "Error: Component '$component' not found. Please create it before proceeding."
            echo "You can use 'add_to_project.sh defaults' to add all default components."
            exit 1
        fi
    done
}

# Ensure all components are present
ensure_components

# Create or overwrite the output file
> "$OUTPUT_FILE"

# Initialize an array to store missing components
missing_components=()

# Read the template file line by line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Use regex to find all placeholders in the line
    while [[ "$line" =~ \{\{([a-zA-Z0-9]+)\}\} ]]; do
        COMPONENT_ID="${BASH_REMATCH[1]}"
        COMPONENT_FILE="${COMPONENT_ID}.html"

        # Check if the component file exists in the current directory
        if [[ -f "$COMPONENT_FILE" ]]; then
            COMPONENT_CONTENT=$(<"$COMPONENT_FILE")
            line="${line/\{\{$COMPONENT_ID\}\}/$COMPONENT_CONTENT}"
        else
            echo "Warning: Component file '$COMPONENT_FILE' not found. Leaving placeholder unchanged."
            missing_components+=("$COMPONENT_ID")
            line="${line/\{\{$COMPONENT_ID\}\}/{{${COMPONENT_ID}}}}"
        fi
    done

    # Write the processed line to the output file
    echo "$line" >> "$OUTPUT_FILE"
done < "$TEMPLATE_FILE"

# Check for any missing components
if [[ ${#missing_components[@]} -gt 0 ]]; then
    echo "The following components were not found and left unchanged:"
    for missing in "${missing_components[@]}"; do
        echo "- {{${missing}}}"
    done
fi

echo "Template processing complete. Check '$OUTPUT_FILE'."
