#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the template and output files
TEMPLATE_FILE="template_default.html"
OUTPUT_FILE="index.html"  # Output file set to index.html

# Default theme if not provided
THEME_NAME=""

# Optional showcase mode
SHOWCASE_MODE=false

# Check if a theme name or showcase parameter was passed as an argument
if [[ ! -z "$1" ]]; then
    if [[ "$1" == "showcase" ]]; then
        SHOWCASE_MODE=true
        TEMPLATE_FILE="./lib/showcase.html"
        OUTPUT_FILE="./lib/showcase_output.html"  # Showcase output file
        echo "Showcase mode enabled. Processing 'showcase.html' in ./lib/."
    else
        THEME_NAME="$1"
        echo "Using theme: $THEME_NAME"
    fi
else
    echo "No theme provided, will not set data-theme attribute or prompt for title."
fi

# Check if the template file exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found."
    exit 1
fi

# If not in showcase mode and a theme is provided, prompt for the page title
if [[ "$SHOWCASE_MODE" == false && ! -z "$1" ]]; then
    read -p "Enter the title for your page (leave empty to use default): " PAGE_TITLE
fi

# Function to ensure all required components exist
ensure_components() {
    for component in sidebarComponent.html contentComponent.html footerComponent.html; do
        if [[ ! -f "$component" ]]; then
            echo "Error: Component '$component' not found. Please create it before proceeding."
            exit 1
        fi
    done
}

# Ensure all components are present if not in showcase mode
if [[ "$SHOWCASE_MODE" == false ]]; then
    ensure_components
fi

# Create or overwrite the output file
> "$OUTPUT_FILE"

# Initialize an array to store missing components
missing_components=()

# Read the template file line by line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Replace the <title> tag with the user-provided title, only if a title is provided and not in showcase mode
    if [[ "$line" =~ \<title\>(.*)\<\/title\> ]] && [[ ! -z "$PAGE_TITLE" ]] && [[ "$SHOWCASE_MODE" == false ]]; then
        echo "Replacing <title> tag with user-provided title."
        line="<title>${PAGE_TITLE}</title>"
    fi

    # Replace the <body> tag with the user-provided theme if a theme is specified
    if [[ "$line" =~ \<body ]]; then
        if [[ ! -z "$THEME_NAME" ]]; then
            echo "Adding data-theme attribute with theme: $THEME_NAME"
            line="<body class=\"flex flex-col min-h-screen\" data-theme=\"$THEME_NAME\">"
        else
            line="<body class=\"flex flex-col min-h-screen\">"
        fi
    fi

    # Use regex to find all placeholders in the line
    while [[ "$line" =~ \{\{([a-zA-Z0-9]+)\}\} ]]; do
        COMPONENT_ID="${BASH_REMATCH[1]}"
        COMPONENT_FILE="${COMPONENT_ID}.html"

        # Check if we are in showcase mode to search in the ./lib/ folder
        if [[ "$SHOWCASE_MODE" == true ]]; then
            COMPONENT_PATH="./lib/$COMPONENT_FILE"
        else
            COMPONENT_PATH="$COMPONENT_FILE"
        fi

        # Check if the component file exists in the appropriate folder
        if [[ -f "$COMPONENT_PATH" ]]; then
            echo "Processing component: $COMPONENT_ID"
            COMPONENT_CONTENT=$(<"$COMPONENT_PATH")

            # Safely escape special characters like &
            COMPONENT_CONTENT=$(echo "$COMPONENT_CONTENT" | sed 's/&/\\&/g')

            line="${line/\{\{$COMPONENT_ID\}\}/$COMPONENT_CONTENT}"
            echo "Replaced {{${COMPONENT_ID}}} successfully."
        else
            echo "Warning: Component file '$COMPONENT_FILE' not found in ${COMPONENT_PATH}. Leaving placeholder unchanged."
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
