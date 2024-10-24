#!/bin/bash
# test_run_create_project.sh

# Color definitions for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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
PROJECT_ROOT="$(find_project_root "$(dirname "${BASH_SOURCE[0]}")")"
if [[ "$PROJECT_ROOT" == "No project root found" ]]; then
    echo -e "${RED}✖ Error: Project root not found.${NC}"
    exit 1
fi

# Define paths
TEST_PROJECTS_DIR="$PROJECT_ROOT/tests/projects"
PUBLIC_DIR="$TEST_PROJECTS_DIR/public"

# Step 1: Run run_create_project.sh
CREATE_PROJECT_SCRIPT="$PROJECT_ROOT/run_create_project.sh"

if [[ ! -f "$CREATE_PROJECT_SCRIPT" ]]; then
    echo -e "${RED}✖ Error: run_create_project.sh not found in $PROJECT_ROOT.${NC}"
    exit 1
fi

# Ensure the test projects directory exists
mkdir -p "$TEST_PROJECTS_DIR"

# Remove existing test project directory if it exists
if [[ -d "$TEST_PROJECTS_DIR/test_project" ]]; then
    rm -rf "$TEST_PROJECTS_DIR/test_project"
fi

# Run the script with a project name and target directory and capture the output
PROJECT_NAME="test_project"
TARGET_DIR="$TEST_PROJECTS_DIR/$PROJECT_NAME"
OUTPUT="$(bash "$CREATE_PROJECT_SCRIPT" "$PROJECT_NAME" "$TARGET_DIR" 2>&1)"

# Check for errors during script run
if echo "$OUTPUT" | grep -q "Error"; then
    echo -e "${RED}✖ Test Failed: Error during run_create_project.sh run.${NC}"
    echo -e "Script output:\n$OUTPUT"
    exit 1
else
    echo -e "${GREEN}✔ Test Passed: run_create_project.sh ran without errors.${NC}"
    echo -e "${YELLOW}Script output:\n$OUTPUT${NC}"
fi

# Step 2: Adjust directory structure to remove double nesting
if [[ -d "$TARGET_DIR/$PROJECT_NAME" ]]; then
    mv "$TARGET_DIR/$PROJECT_NAME"/* "$TARGET_DIR/"
    rmdir "$TARGET_DIR/$PROJECT_NAME"
fi

# Step 3: Run run_generate.sh to generate index.html
RUN_GENERATE_SCRIPT="$TARGET_DIR/run_generate.sh"
if [[ -f "$RUN_GENERATE_SCRIPT" ]]; then
    (cd "$TARGET_DIR" && bash "$RUN_GENERATE_SCRIPT")
    echo -e "${GREEN}✔ run_generate.sh executed successfully.${NC}"
else
    echo -e "${RED}✖ Error: run_generate.sh not found in '$TARGET_DIR'.${NC}"
    exit 1
fi

# Step 4: Verify generated project output
if [[ ! -f "$TARGET_DIR/index.html" ]]; then
    echo -e "${RED}✖ Error: Generated output 'index.html' not found in test projects directory for project '$PROJECT_NAME'.${NC}"
    echo -e "${YELLOW}Ensure the project name is correct. The generated output should be in the 'tests/projects/$PROJECT_NAME' directory.${NC}"
    exit 1
else
    echo -e "${GREEN}✔ Generated output 'index.html' found for project '$PROJECT_NAME'.${NC}"
fi

# Final result
echo -e "${GREEN}✔ run_create_project.sh validation completed successfully.${NC}"
exit 0
