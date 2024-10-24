#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"  # Assuming the project root is one level up from scripts

# Define the template and output files
TEMPLATE_FILE="template_default.html"
OUTPUT_FILE="index.html"  # Output file set to index.html

# Default theme if not provided (optional)
THEME_NAME=""

# Check if a theme name was passed as an argument
if [[ ! -z "$1" ]]; then
    THEME_NAME="$1"
    echo "Using theme: $THEME_NAME"
else
    echo "No theme provided, proceeding without data-theme attribute."
fi

# Check if the template file exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found. Use './run_add.sh template_default.html' to add the default template file."
    exit 1
fi

# Prompt for the page title if a theme is provided
if [[ ! -z "$THEME_NAME" ]]; then
    read -p "Enter the title for your page (leave empty to use default): " PAGE_TITLE
fi

# Function to ensure required components exist
ensure_components() {
    local missing=()
    for component in sidebar_default content_default footer_default; do
        local component_file="./${component}.html"
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

# Ensure all required components are present
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
        if [[ ! -z "$THEME_NAME" ]]; then
            echo "Adding data-theme attribute with theme: $THEME_NAME"
            line="<body class=\"flex flex-col min-h-screen\" data-theme=\"$THEME_NAME\">"
        else
            line="<body class=\"flex flex-col min-h-screen\">"
        fi
    fi

    # Use regex to find all placeholders in the format {{component_name}}
    while [[ "$line" =~ \{\{([a-zA-Z0-9_]+)\}\} ]]; do
        COMPONENT_ID="${BASH_REMATCH[1]}"
        COMPONENT_FILE="${COMPONENT_ID}.html"

        # Check if the component file exists
        if [[ -f "$COMPONENT_FILE" ]]; then
            echo "Processing component: $COMPONENT_ID"
            COMPONENT_CONTENT=$(<"$COMPONENT_FILE")

            # Safely escape special characters like &
            COMPONENT_CONTENT=$(echo "$COMPONENT_CONTENT" | sed 's/&/\\&/g')

            # Replace the placeholder with the component content
            line="${line/\{\{$COMPONENT_ID\}\}/$COMPONENT_CONTENT}"
            echo "Replaced {{${COMPONENT_ID}}} successfully."
        else
            echo "Warning: Component file '$COMPONENT_ID.html' not found in '$components_dir/default/'. Leaving placeholder unchanged."
            missing_components+=("$COMPONENT_ID")
            # Optionally, keep the placeholder or replace it with an empty string
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
