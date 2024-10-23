#!/bin/bash

# Test script for Component ID Handling with consistent formatting

echo -e "\n--- Initializing test: Component ID Handling Test ---"

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

# For each component file in the test directory, check if the id matches the filename
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
                echo -e "${GREEN}✔ Component ID matches filename for ${FILENAME}${NC}"
            else
                echo -e "${RED}✖ Component ID does NOT match filename for ${FILENAME}${NC}"
                TEST_PASSED=false
            fi
        else
            echo -e "${RED}✖ No id attribute found in ${FILENAME}${NC}"
            TEST_PASSED=false
        fi
    else
        echo -e "${RED}✖ Component file ${FILENAME} not found.${NC}"
        TEST_PASSED=false
    fi
done

# Final result
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN}✔ Component ID handling test passed.${NC}"
    exit 0
else
    echo -e "${RED}✖ Component ID handling test failed.${NC}"
    exit 1
fi
