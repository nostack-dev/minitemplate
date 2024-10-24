#!/bin/bash
# repository_setup_validation.sh

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
TEMPLATES_DIR="$PROJECT_ROOT/templates"
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
TESTS_DIR="$PROJECT_ROOT/tests"
README_FILE="$PROJECT_ROOT/README.md"

# Step 1: Verify repository structure
if [[ ! -d "$COMPONENTS_DIR" || ! -d "$TEMPLATES_DIR" || ! -d "$SCRIPTS_DIR" || ! -d "$TESTS_DIR" ]]; then
    echo -e "${RED}✖ Error: Repository structure is incorrect. Required directories are missing.${NC}"
    exit 1
else
    echo -e "${GREEN}✔ Repository structure verified.${NC}"
fi

# Step 2: Verify required components and templates
REQUIRED_COMPONENTS=("sidebar_default.html" "content_default.html" "footer_default.html")
for component in "${REQUIRED_COMPONENTS[@]}"; do
    if [[ ! -f "$COMPONENTS_DIR/$component" ]]; then
        echo -e "${RED}✖ Error: Required component '$component' not found in $COMPONENTS_DIR.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✔ Component '$component' found.${NC}"
done

if [[ ! -f "$TEMPLATES_DIR/template_default.html" ]]; then
    echo -e "${RED}✖ Error: Template 'template_default.html' not found in $TEMPLATES_DIR.${NC}"
    exit 1
else
    echo -e "${GREEN}✔ Template 'template_default.html' found.${NC}"
fi

# Step 3: Extract steps from README.md and validate
if [[ ! -f "$README_FILE" ]]; then
    echo -e "${RED}✖ Error: README.md file not found in project root.${NC}"
    exit 1
fi

# Extract commands from README.md (assuming commands are in code blocks starting with '$')
README_COMMANDS=$(grep -oP '(?<=\$ ).*' "$README_FILE")

for cmd in $README_COMMANDS; do
    if ! command -v $(echo $cmd | awk '{print $1}') &> /dev/null; then
        echo -e "${RED}✖ Error: Command '$cmd' from README.md is not available.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✔ Command '$cmd' from README.md is available.${NC}"
done

# Step 4: Verify generated output
if [[ ! -f "$PROJECT_ROOT/public/index.html" ]]; then
    echo -e "${RED}✖ Error: Generated output 'index.html' not found in public directory.${NC}"
    exit 1
else
    echo -e "${GREEN}✔ Generated output 'index.html' found.${NC}"
fi

# Final result
echo -e "${GREEN}✔ Repository setup validation completed successfully.${NC}"
exit 0
