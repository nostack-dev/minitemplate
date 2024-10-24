#!/bin/bash
# component_dependency_validation.sh

# Color definitions for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to find project root
find_project_root() {
    local dir="$(cd "${1:-$(pwd)}" && pwd)"
    local root_files=("README.md" "LICENSE" "CONTRIBUTE.md" "CNAME")

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

# Define paths
COMPONENTS_DIR="$PROJECT_ROOT/components/default"
TESTS_DIR="$PROJECT_ROOT/tests"

# Ensure the necessary components exist in the components directory
if [[ ! -d "$COMPONENTS_DIR" ]]; then
    echo -e "${RED}✖ Error: Components directory not found at $COMPONENTS_DIR.${NC}"
    exit 1
fi

# Initialize test result
TEST_PASSED=true

# For each component file, check for references to other components
for COMPONENT_FILE in "$COMPONENTS_DIR"/*.html; do
    if [[ -f "$COMPONENT_FILE" ]]; then
        FILENAME=$(basename "$COMPONENT_FILE")
        COMPONENT_CONTENT=$(<"$COMPONENT_FILE")

        # Extract all component references in the format {{component_name}}
        REFERENCES=$(echo "$COMPONENT_CONTENT" | grep -oP '\{\{\s*\K\w+(?=\s*\}\})')

        for REFERENCE in $REFERENCES; do
            REFERENCE_FILE="$COMPONENTS_DIR/${REFERENCE}.html"
            if [[ ! -f "$REFERENCE_FILE" ]]; then
                echo -e "${RED}✖ Missing referenced component: ${REFERENCE}.html in $FILENAME${NC}"
                TEST_PASSED=false
            else
                echo -e "${GREEN}✔ Referenced component ${REFERENCE}.html found for $FILENAME${NC}"
            fi
        done
    else
        echo -e "${RED}✖ Component file $FILENAME not found.${NC}"
        TEST_PASSED=false
    fi
done

# Final result
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN}✔ Component dependency validation test passed.${NC}"
    exit 0
else
    echo -e "${RED}✖ Component dependency validation test failed.${NC}"
    exit 1
fi
