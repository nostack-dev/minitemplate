#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the template and output files
TEMPLATE_FILE="template.html"
OUTPUT_FILE="index.html"  # Output file set to index.html

# Default theme if not provided
THEME_NAME="business"

# Check if a theme name was passed as an argument
if [[ ! -z "$1" ]]; then
    THEME_NAME="$1"
    echo "Using theme: $THEME_NAME"
else
    echo "No theme provided, using default: $THEME_NAME"
fi

# Check if the template file exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found."
    exit 1
fi

# Prompt the user for the page title
read -p "Enter the title for your page: " PAGE_TITLE

# Function to ensure all required components exist
ensure_components() {
    for component in sidebarComponent.html contentComponent.html footerComponent.html; do
        if [[ ! -f "$component" ]]; then
            echo "Error: Component '$component' not found. Please create it before proceeding."
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
    # Replace the <title> tag with the user-provided title
    if [[ "$line" =~ \<title\>(.*)\<\/title\> ]]; then
        echo "Replacing <title> tag with user-provided title."
        line="<title>${PAGE_TITLE}</title>"
    fi

    # Replace the <body> tag with the user-provided theme
    if [[ "$line" =~ \<body ]]; then
        echo "Adding data-theme attribute with theme: $THEME_NAME"
        line="<body class=\"flex flex-col min-h-screen\" data-theme=\"$THEME_NAME\">"
    fi

    # Use regex to find all placeholders in the line
    while [[ "$line" =~ \{\{([a-zA-Z0-9]+)\}\} ]]; do
        COMPONENT_ID="${BASH_REMATCH[1]}"
        COMPONENT_FILE="${COMPONENT_ID}.html"

        # Check if the component file exists
        if [[ -f "$COMPONENT_FILE" ]]; then
            echo "Processing component: $COMPONENT_ID"
            COMPONENT_CONTENT=$(<"$COMPONENT_FILE")

            # Safely escape special characters like &
            COMPONENT_CONTENT=$(echo "$COMPONENT_CONTENT" | sed 's/&/\\&/g')

            line="${line/\{\{$COMPONENT_ID\}\}/$COMPONENT_CONTENT}"
            echo "Replaced {{${COMPONENT_ID}}} successfully."
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
