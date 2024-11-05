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
THEME_NAME=""
# Default title
DEFAULT_TITLE="My Default Title"

# Check if a theme name was passed as an argument
if [[ ! -z "$2" ]]; then
    THEME_NAME="$2"
    echo "Using theme: $THEME_NAME"
else
    echo "No theme provided, proceeding without data-theme attribute."
fi

# Check if a custom title was provided as the third argument
if [[ ! -z "$3" ]]; then
    PAGE_TITLE="$3"
    echo "Using custom title: $PAGE_TITLE"
else
    PAGE_TITLE="$DEFAULT_TITLE"
    echo "No custom title provided, using default title: $PAGE_TITLE"
fi

# Check if the template file exists in the project directory
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found in project directory."
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
    # Replace the <title> tag with the user-provided or default title
    if [[ "$line" =~ \<title\>(.*)\<\/title\> ]]; then
        echo "Replacing <title> tag with provided title."
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
        COMPONENT_FILE="$PROJECT_DIR/${COMPONENT_ID}.html"

        # Check if the component file exists in the project directory
        if [[ -f "$COMPONENT_FILE" ]]; then
            echo "Processing component: $COMPONENT_ID"
            COMPONENT_CONTENT=$(<"$COMPONENT_FILE")

            # Safely escape special characters like &
            COMPONENT_CONTENT=$(echo "$COMPONENT_CONTENT" | sed 's/&/\\&/g')

            # Replace the placeholder with the component content
            line="${line/\{\{$COMPONENT_ID\}\}/$COMPONENT_CONTENT}"
            echo "Replaced {{${COMPONENT_ID}}} successfully."
        else
            echo "Warning: Component file '$COMPONENT_ID.html' not found in '$PROJECT_DIR'. Leaving placeholder unchanged."
            missing_components+=("$COMPONENT_ID")
            # Optionally, keep the placeholder or replace it with an empty string
            line="${line/\{\{$COMPONENT_ID\}\}/{{${COMPONENT_ID}}}}"
        fi
    done

    # Write the processed line to the output file
    echo "$line" >> "$OUTPUT_FILE"
done < "$TEMPLATE_FILE"

# Add JavaScript for template instantiation at the end of the output file
cat << EOF >> "$OUTPUT_FILE" 
<script>
const instantiatedElements = []; // Array to keep track of instantiated elements

window.instantiate = function(templateId, insertLocationId) {
    const template = document.getElementById(templateId);
    if (template) {
        const clone = document.importNode(template.content, true);
        const insertLocation = document.getElementById(insertLocationId);
        if (insertLocation) {
            const instantiatedElement = document.createElement('div'); // Create a wrapper for the instance
            instantiatedElement.appendChild(clone); // Append the cloned template content to the wrapper
            insertLocation.appendChild(instantiatedElement); // Append the wrapper to the insert location
            
            // Store the reference of the instantiated element
            instantiatedElements.push({ templateId, insertLocationId, element: instantiatedElement });
        } else {
            console.warn('Insert location with ID "' + insertLocationId + '" not found.');
        }
    } else {
        console.error('Template with ID "' + templateId + '" not found.');
    }
};

window.uninstantiate = function(templateId, insertLocationId) {
    // Find the index of the instantiated element that matches the parameters
    const index = instantiatedElements.findIndex(inst => inst.templateId === templateId && inst.insertLocationId === insertLocationId);

    if (index !== -1) {
        const { element } = instantiatedElements[index];
        const insertLocation = document.getElementById(insertLocationId);
        
        if (insertLocation) {
            insertLocation.removeChild(element); // Remove the element from the insert location
            instantiatedElements.splice(index, 1); // Remove from the tracking array
        } else {
            console.error('Insert location with ID "' + insertLocationId + '" not found.');
        }
    } else {
        console.warn('No instantiated element found for template ID "' + templateId + '" and insert location ID "' + insertLocationId + '".');
    }
};
</script>
EOF

# Check for any missing components
if [[ ${#missing_components[@]} -gt 0 ]]; then
    echo "The following components were not found and left unchanged:"
    for missing in "${missing_components[@]}"; do
        echo "- {{${missing}}}"
    done
fi

echo "Template processing complete. Check '$OUTPUT_FILE'."
