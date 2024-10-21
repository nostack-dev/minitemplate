#!/bin/bash
# Test Component Creation Script

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cp createcomponent.sh "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

# Run the test
COMPONENT_NAME="testComponent"
./createcomponent.sh "$COMPONENT_NAME"

if [ -f "${COMPONENT_NAME}Component.html" ]; then
    echo "Test passed: ${COMPONENT_NAME}Component.html exists"
else
    echo "Test failed: ${COMPONENT_NAME}Component.html does not exist"
    exit 1
fi

# Check if the component contains the button
if grep -q 'class="btn"' "${COMPONENT_NAME}Component.html"; then
    echo "Test passed: ${COMPONENT_NAME}Component.html contains button"
else
    echo "Test failed: ${COMPONENT_NAME}Component.html missing button"
    exit 1
fi

# Clean up
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up."
