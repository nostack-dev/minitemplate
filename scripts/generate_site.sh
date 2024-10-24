#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"  # Assuming the project root is one level up from scripts

# Get the project directory passed as an argument, default to current directory if not provided
PROJECT_DIR="${1:-$(pwd)}"

# Define the template and output files within the project directory
TEMPLATE_FILE="$PROJECT_DIR/template_default.html"
OUTPUT_FILE="$PROJECT_DIR/index.html"  # Output file set to index.html

# Default theme if not provided (optional)
THEME_NAME="$2"

# Check if a theme name was passed as an argument
if [[ ! -z "$THEME_NAME" ]]; then
    echo "Using theme: $THEME_NAME"
else
    THEME_NAME="default"
    echo "No theme provided, proceeding with default theme."
fi

# Check if the template file exists in the project directory
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found in project directory. Use './run_add.sh template_default.html' to add the default template file."
    exit 1
fi

# Function to ensure required components exist in the project directory
ensure_components() {
    local missing=()
    for component in sidebar_default content_default footer_default; do
        local component_file="$PROJECT_DIR/${component}.html"
        if [[ ! -f "$component_file" ]]; then
            missing+=("$component")
        fi
    done

    if [[ ${#missing[@]} -ne 0 ]]; then
        echo "Error: The following required components are missing:"
        for comp in "${missing[@]}"; do
            echo "- $comp.html"
        done
        echo "Please add them using './run_add.sh defaults' or individually."
        exit 1
    fi
}

# Ensure all required components are present in the project directory
ensure_components

# Create or overwrite the output file
> "$OUTPUT_FILE"

# Initialize an array to store missing components
missing_components=()

# Read the template file line by line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Replace the <title> tag with the user-provided title, if provided
    if [[ "$line" =~ \<title\>(.*)\<\/title\> ]] && [[ ! -z "$PAGE_TITLE" ]]; then
        echo "Replacing <title> tag with user-provided title."
        line="<title>${PAGE_TITLE}</title>"
    fi

    # Replace the <body> tag with the data-theme attribute if a theme is specified
    if [[ "$line" =~ \<body ]]; then
        echo "Adding data-theme attribute with theme: $THEME_NAME"
        line="<body class=\"flex flex-col min-h-screen\" data-theme=\"$THEME_NAME\">"
    fi

    # Process components
    while [[ "$line" =~ \{\{([a-zA-Z0-9_]+)\}\} ]]; do
        COMPONENT_ID="${BASH_REMATCH[1]}"
        COMPONENT_FILE="$PROJECT_DIR/${COMPONENT_ID}.html"

        if [[ -f "$COMPONENT_FILE" ]]; then
            COMPONENT_CONTENT=$(<"$COMPONENT_FILE")
            COMPONENT_CONTENT=$(echo "$COMPONENT_CONTENT" | sed 's/&/\\&/g')
            line="${line/\{\{$COMPONENT_ID\}\}/$COMPONENT_CONTENT}"
        else
            line="${line/\{\{$COMPONENT_ID\}\}/}"
        fi
    done

    # Write the processed line to the output file
    echo "$line" >> "$OUTPUT_FILE"
done < "$TEMPLATE_FILE"

echo "Template processing complete. Check '$OUTPUT_FILE'."
