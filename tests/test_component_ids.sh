#!/bin/bash

# Test script for Component ID Handling
# This script checks if the component IDs in your HTML files match their filenames.

# Initialize
echo "Initializing test: Component ID Handling Test"

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/../tests"
ROOT_DIR="$SCRIPT_DIR/../"

# Ensure the test directory exists
mkdir -p "$TEST_DIR"

# Copy all component files ending with 'Component.html' from root to test directory
cp "$ROOT_DIR"*Component.html "$TEST_DIR/"

# Initialize test result
TEST_PASSED=true

# For each component file in the test directory, extract its ID and check if it matches the filename (excluding .html)
for COMPONENT_FILE in "$TEST_DIR/"*Component.html; do
    if [[ -f "$COMPONENT_FILE" ]]; then
        FILENAME=$(basename "$COMPONENT_FILE")
        COMPONENT_ID="${FILENAME%.html}"  # Remove .html extension

        # Read the content of the component file
        COMPONENT_CONTENT=$(<"$COMPONENT_FILE")

        # Extract the id attribute value using regex
        if [[ "$COMPONENT_CONTENT" =~ id=\"([^\"]+)\" ]]; then
            ID_ATTRIBUTE="${BASH_REMATCH[1]}"
            if [[ "$ID_ATTRIBUTE" == "$COMPONENT_ID" ]]; then
                echo "✔ Component ID matches filename for $FILENAME"
            else
                echo "✖ Component ID does NOT match filename for $FILENAME"
                echo "   Expected ID: $COMPONENT_ID"
                echo "   Found ID:    $ID_ATTRIBUTE"
                TEST_PASSED=false
            fi
        else
            echo "✖ No id attribute found in $FILENAME"
            TEST_PASSED=false
        fi
    else
        echo "✖ Component file $COMPONENT_FILE not found."
        TEST_PASSED=false
    fi
done

if [ "$TEST_PASSED" = true ]; then
    echo -e "\nComponent ID handling test passed."
    RESULT=0
else
    echo -e "\nComponent ID handling test failed."
    RESULT=1
fi

exit $RESULT
