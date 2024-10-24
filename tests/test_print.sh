#!/bin/bash
# Test script for verifying print output

# Color definitions for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\n--- Initializing test: Print Output Validation ---"

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../"  # Assuming the project root is two levels up from the script
LIB_DIR="$PROJECT_ROOT/components"
COMPONENTS_DIR="$LIB_DIR/default"
TEMPLATE_FILE="$PROJECT_ROOT/templates/template_default.html"

# Ensure the components and template file exist
if [ ! -d "$COMPONENTS_DIR" ]; then
    echo -e "${RED}✖ Error: Directory '$COMPONENTS_DIR' not found!${NC}"
    exit 1
fi

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}✖ Error: Template file '$TEMPLATE_FILE' not found!${NC}"
    exit 1
fi

# Initialize test result
TEST_PASSED=true

# Copy necessary files to the current directory
echo -e "\n--- Copying files for the test ---"
cp "$PROJECT_ROOT/print.sh" . || { echo -e "${RED}✖ Error: Failed to copy print.sh.${NC}"; TEST_PASSED=false; }
cp "$TEMPLATE_FILE" . || { echo -e "${RED}✖ Error: Failed to copy template_default.html.${NC}"; TEST_PASSED=false; }

# Copy all default components to the test directory
echo -e "\n--- Adding default components ---"
cp "$COMPONENTS_DIR/"*.html . || { echo -e "${RED}✖ Error: Failed to copy components.${NC}"; TEST_PASSED=false; }

# Run the print.sh script and check the output directly
echo -e "\n--- Running print.sh script ---"
if ./print.sh | grep -q "Contents of ./template_default.html"; then
    echo -e "${GREEN}✔ Test passed: template_default.html is included in the print output.${NC}"
else
    echo -e "${RED}✖ Test failed: template_default.html is missing from the print output.${NC}"
    TEST_PASSED=false
fi

# Final result for this test script
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN}✔ All files verified in the print output.${NC}"
    exit 0
else
    echo -e "${RED}✖ One or more tests failed in print output validation.${NC}"
    exit 1
fi
