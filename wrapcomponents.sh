#!/bin/bash

# Script to wrap all HTML components in the root folder that match specific naming conventions into <template> tags

for COMPONENT_FILE in ./*Component.html; do
    if [[ -f "$COMPONENT_FILE" ]]; then
        TEMPLATE_FILE="${COMPONENT_FILE%.html}Wrapped.html"
        COMPONENT_NAME=$(basename "$COMPONENT_FILE" .html)

        # Read the contents of the component file
        COMPONENT_CONTENT=$(<"$COMPONENT_FILE")

        # Remove any placeholders like {{blablaComponent}}
        COMPONENT_CONTENT=$(echo "$COMPONENT_CONTENT" | sed -E 's/\{\{[a-zA-Z0-9]+Component\}\}//g')

        # Create the template file by wrapping the component content
        cat <<EOL > "$TEMPLATE_FILE"
<!-- Wrapped template of $COMPONENT_FILE -->
<template id="${COMPONENT_NAME}">
    $COMPONENT_CONTENT
</template>
EOL

        echo "Template '$TEMPLATE_FILE' created successfully."
    fi
done
