#!/bin/bash
# test_placeholder_syntax.sh

# Color definitions for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\n--- Running Test: Placeholder Syntax and Operator Validation ---"

# Function to find project root
find_project_root() {
    local dir="$(cd "${1:-$(pwd)}" && pwd)"
    local root_files=("README.md" "LICENSE" "CONTRIBUTING.md" "CNAME")

    while [[ "$dir" != "/" ]]; do
        for file in "${root_files[@]}"; do
            if [[ -f "$dir/$file" ]]; then
                echo "$dir"
                return 0
            fi
        done
        dir=$(dirname "$dir")
    done
    echo "No project root found"
    return 1
}

# Locate the project root
PROJECT_ROOT=$(find_project_root "$(dirname "${BASH_SOURCE[0]}")")

if [[ -z "$PROJECT_ROOT" ]]; then
    echo -e "${RED}✖ Error: Could not find the project root.${NC}"
    exit 1
fi

# Define paths
COMPONENTS_DIR="$PROJECT_ROOT/components/default"
TEMPLATES_DIR="$PROJECT_ROOT/templates"
TESTS_DIR="$PROJECT_ROOT/tests"
GENERATE_SCRIPT="$PROJECT_ROOT/scripts/run_generate.sh"

# Debugging: Output paths being used
echo "COMPONENTS_DIR: $COMPONENTS_DIR"
echo "TEMPLATES_DIR: $TEMPLATES_DIR"
echo "TESTS_DIR: $TESTS_DIR"
echo "GENERATE_SCRIPT: $GENERATE_SCRIPT"

# Ensure the necessary components exist and copy them to the test directory
for component in sidebar_default content_default footer_default; do
    COMPONENT_PATH="$COMPONENTS_DIR/${component}.html"
    if [ ! -f "$COMPONENT_PATH" ]; then
        echo -e "${RED}✖ Error: Required component file '${component}.html' not found in $COMPONENTS_DIR.${NC}"
        exit 1
    fi
    echo "Copying $COMPONENT_PATH to $TESTS_DIR"
    cp "$COMPONENT_PATH" "$TESTS_DIR"
done

# Ensure the template file is available in the test directory
if [ ! -f "$TEMPLATES_DIR/template_default.html" ]; then
    echo -e "${RED}✖ Error: Template file 'template_default.html' not found in $TEMPLATES_DIR.${NC}"
    exit 1
fi
echo "Copying template_default.html to $TESTS_DIR/template_default.html"
cp "$TEMPLATES_DIR/template_default.html" "$TESTS_DIR/template_default.html"

# Define the test template
TEST_TEMPLATE="$TESTS_DIR/test_placeholder_syntax_template.html"

# Copy the default template to the test template
cp "$TEMPLATES_DIR/template_default.html" "$TEST_TEMPLATE"

# Introduce a malformed placeholder (missing closing brace)
sed -i 's/{{sidebar_default}}/{{sidebar_default}/g' "$TEST_TEMPLATE"

# Pre-run check for malformed placeholders
MALFORMED_PLACEHOLDER=$(grep -oP '\{\{[^\}]*' "$TEST_TEMPLATE")
if [[ ! -z "$MALFORMED_PLACEHOLDER" ]]; then
    echo -e "${GREEN}✔ Test Passed: Detected malformed placeholder before template processing.${NC}"
else
    echo -e "${RED}✖ Test Failed: No malformed placeholder detected before template processing.${NC}"
    exit 1
fi

# Run the generate script with the correct template in the tests directory
OUTPUT=$("$GENERATE_SCRIPT" "" "$TESTS_DIR/template_default.html" 2>&1)

# Check for errors in the generation script
if echo "$OUTPUT" | grep -q "Error"; then
    echo -e "${RED}✖ Test Failed: Error during generation script run.${NC}"
    echo -e "Generation script output:\n$OUTPUT"
    exit 1
else
    echo -e "${GREEN}✔ Test Passed: Generation script ran without errors.${NC}"
fi
