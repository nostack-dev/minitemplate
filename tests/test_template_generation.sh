#!/bin/bash
# Test script for Template Generation with unified output

# Color definitions for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\n--- Initializing test: Template Generation ---"

# Find the root directory of the project
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."  # Assuming the project root is two levels up from the script
LIB_DIR="$PROJECT_ROOT/components"
COMPONENTS_DIR="$LIB_DIR/default"
TEMPLATE_FILE="$PROJECT_ROOT/templates/template_default.html"

# Ensure necessary files and directories exist
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
echo -e "\n--- Copying template and component files for the test ---"
cp "$PROJECT_ROOT/scripts/generate_site.sh" ./ || { echo -e "${RED}✖ Error: Failed to copy generate_site.sh.${NC}"; TEST_PASSED=false; }
cp "$TEMPLATE_FILE" . || { echo -e "${RED}✖ Error: Failed to copy template_default.html.${NC}"; TEST_PASSED=false; }
cp "$COMPONENTS_DIR/header_default.html" "$COMPONENTS_DIR/content_default.html" "$COMPONENTS_DIR/sidebar_default.html" "$COMPONENTS_DIR/footer_default.html" . || { echo -e "${RED}✖ Error: Failed to copy component files.${NC}"; TEST_PASSED=false; }

# Provide a default title for the test
export PAGE_TITLE="Test Page Title"

# Check if all required components exist
for component in "footer_default.html" "header_default.html" "content_default.html" "sidebar_default.html"; do
    if [ -f "$component" ]; then
        echo -e "${GREEN}✔ $component found.${NC}"
    else
        echo -e "${RED}✖ $component is missing.${NC}"
        TEST_PASSED=false
    fi
done

# Check if the template file exists before running the test
if [ ! -f "template_default.html" ]; then
    echo -e "${RED}✖ Error: Template file 'template_default.html' not found.${NC}"
    TEST_PASSED=false
else
    # Run the test for template generation
    echo "$PAGE_TITLE" | ./generate_site.sh

    # Check if index.html was generated
    echo -e "\n--- Checking generated output ---"
    if [ -f "index.html" ]; then
        echo -e "${GREEN}✔ Test passed: index.html exists.${NC}"
    else
        echo -e "${RED}✖ Test failed: index.html does not exist.${NC}"
        TEST_PASSED=false
    fi

    # Check if headerComponent is included in index.html
    if grep -q '<div id="header_default"' "index.html"; then
        echo -e "${GREEN}✔ Test passed: header_default Component included in index.html.${NC}"
    else
        echo -e "${RED}✖ Test failed: header_default Component missing in index.html.${NC}"
        TEST_PASSED=false
    fi
fi

# Final result for this test script
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN}✔ All checks passed for template generation.${NC}"
    exit 0
else
    echo -e "${RED}✖ One or more tests failed in template generation.${NC}"
    exit 1
fi
