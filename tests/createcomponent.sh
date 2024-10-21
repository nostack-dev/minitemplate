#!/bin/bash

# Script to create a new component HTML file with the specified structure.

if [ -z "$1" ]; then
    echo "Error: No component name provided."
    echo "Usage: ./createcomponent.sh [componentName]"
    exit 1
fi

COMPONENT_NAME="$1"
COMPONENT_FILE="${COMPONENT_NAME}Component.html"

# Check if the component file already exists
if [ -f "$COMPONENT_FILE" ]; then
    echo "Error: Component '$COMPONENT_FILE' already exists."
    exit 1
fi

# Create the component file with the basic structure using minimal DaisyUI
cat <<EOL > "$COMPONENT_FILE"
<!-- $COMPONENT_FILE -->
<div id="${COMPONENT_NAME}Component">
    <!-- Add your component HTML here -->
    <button class="btn">Action</button>

    <script>
        // Add your component-specific JavaScript here
        (function() {
            // Ensures the script runs only after the document is fully loaded
            document.addEventListener('DOMContentLoaded', function() {
                console.log('${COMPONENT_NAME} component loaded.');
            });
        })();
    </script>
</div>
EOL

echo "Component '$COMPONENT_FILE' created successfully."
