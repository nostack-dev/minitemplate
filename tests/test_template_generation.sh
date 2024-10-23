#!/bin/bash
# Test script for Template Generation with unified output

# Color definitions for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\n--- Initializing test: Template Generation ---"

# Find the root directory of the project
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../"  # Assuming the project root is two levels up from the script
LIB_DIR="$PROJECT_ROOT/lib"
COMPONENTS_DIR="$LIB_DIR/components_default"
TEMPLATE_FILE="$LIB_DIR/templates/template_default.html"

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
cp "$PROJECT_ROOT/generate.sh" . || { echo -e "${RED}✖ Error: Failed to copy generate.sh.${NC}"; TEST_PASSED=false; }
cp "$TEMPLATE_FILE" . || { echo -e "${RED}✖ Error: Failed to copy template_default.html.${NC}"; TEST_PASSED=false; }
cp "$COMPONENTS_DIR/headerComponent.html" "$COMPONENTS_DIR/contentComponent.html" "$COMPONENTS_DIR/sidebarComponent.html" "$COMPONENTS_DIR/footerComponent.html" . || { echo -e "${RED}✖ Error: Failed to copy component files.${NC}"; TEST_PASSED=false; }

# Provide a default title for the test
export PAGE_TITLE="Test Page Title"

# Check if all required components exist
for component in "footerComponent.html" "headerComponent.html" "contentComponent.html" "sidebarComponent.html"; do
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
    # Run the test for template generation with the light theme, and specify the correct template file
    echo "$PAGE_TITLE" | ./generate.sh "light" "template_default.html"

    # Check if index.html was generated
    echo -e "\n--- Checking generated output ---"
    if [ -f "index.html" ]; then
        echo -e "${GREEN}✔ Test passed: index.html exists.${NC}"
    else
        echo -e "${RED}✖ Test failed: index.html does not exist.${NC}"
        TEST_PASSED=false
    fi

    # Check if the correct theme is applied in the generated file
    if grep -q 'data-theme="light"' "index.html"; then
        echo -e "${GREEN}✔ Test passed: index.html has correct theme.${NC}"
    else
        echo -e "${RED}✖ Test failed: Theme not applied correctly in index.html.${NC}"
        TEST_PASSED=false
    fi

    # Check if headerComponent is included in index.html
    if grep -q '<div id="headerComponent"' "index.html"; then
        echo -e "${GREEN}✔ Test passed: headerComponent included in index.html.${NC}"
    else
        echo -e "${RED}✖ Test failed: headerComponent missing in index.html.${NC}"
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
