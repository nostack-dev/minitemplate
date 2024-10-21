#!/bin/bash

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cp wrapcomponents.sh headerComponent.html sidebarComponent.html footerComponent.html "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

# Run the wrapping script
./wrapcomponents.sh

# Test the wrapped components in the temporary directory
for component in headerComponent sidebarComponent footerComponent; do
    if [ -f "./wrapped/${component}Wrapped.html" ]; then
        echo "Test passed: ${component}Wrapped.html exists"
    else
        echo "Test failed: ${component}Wrapped.html does not exist"
        exit 1
    fi

    if grep -q "<template" "./wrapped/${component}Wrapped.html"; then
        echo "Test passed: ${component}Wrapped.html contains <template> tag"
    else
        echo "Test failed: ${component}Wrapped.html missing <template> tag"
        exit 1
    fi
done

# Clean up
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up."
