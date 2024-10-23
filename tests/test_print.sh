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
LIB_DIR="$PROJECT_ROOT/lib"
COMPONENTS_DIR="$LIB_DIR/components_default"
TEMPLATE_FILE="$LIB_DIR/templates/template_default.html"
TEST_DIR="$SCRIPT_DIR"

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
cp "$PROJECT_ROOT/README.md" . || { echo -e "${RED}✖ Error: Failed to copy README.md.${NC}"; TEST_PASSED=false; }
cp "$TEMPLATE_FILE" . || { echo -e "${RED}✖ Error: Failed to copy template_default.html.${NC}"; TEST_PASSED=false; }

# Copy all default components to the test directory
echo -e "\n--- Adding default components ---"
cp "$COMPONENTS_DIR/"*.html "$TEST_DIR/" || { echo -e "${RED}✖ Error: Failed to copy components.${NC}"; TEST_PASSED=false; }

# Run the print.sh script and capture output
./print.sh > output.txt || { echo -e "${RED}✖ Error: Failed to run print.sh.${NC}"; TEST_PASSED=false; }

# Test for the presence of specific files in the output
for file in README.md template_default.html ; do
    echo -e "\n--- Checking print output for $file ---"
    if grep -q "Contents of ./$file" output.txt; then
        echo -e "${GREEN}✔ Test passed: $file is included in the print output.${NC}"
    else
        echo -e "${RED}✖ Test failed: $file is missing from the print output.${NC}"
        TEST_PASSED=false
    fi
done

# Final result for this test script
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN}✔ All files verified in the print output.${NC}"
    exit 0
else
    echo -e "${RED}✖ One or more tests failed in print output validation.${NC}"
    exit 1
fi
