#!/bin/bash

# Find the project root
find_root() {
    local dir="$(cd "${1:-$(pwd)}" && pwd)"  # Convert to absolute path
    local root_files=("README.md" "LICENSE" "CONTRIBUTE.md" "CNAME")

    while [[ "$dir" != "/" ]]; do
        for file in "${root_files[@]}"; do
            if [[ -f "$dir/$file" ]]; then
                echo "$dir"
                return 0
            fi
        done
        dir=$(dirname "$dir")  # Move one level up
    done

    echo "No project root found"
    return 1
}

# Get the project root dynamically
root=$(find_root)

if [[ -z "$root" ]]; then
    echo "Error: Project root not found."
    exit 1
fi

# Copy run_create_project.sh from the scripts folder to the tests folder
if [[ -f "$root/run_create_project.sh" ]]; then
    cp "$root/run_create_project.sh" "$root/tests/"
    echo "Copied run_create_project.sh to the tests directory."
else
    echo "Error: run_create_project.sh not found in the scripts directory."
    exit 1
fi

# Set up variables for test
test_project="test_project_theme"
test_theme="dark"
template_file="$root/tests/projects/$test_project/template_default.html"

# Remove any previous test project
if [[ -d "$root/tests/projects/$test_project" ]]; then
    echo "Removing previous test project..."
    rm -rf "$root/tests/projects/$test_project"
fi

# Run the project creation script with test project name and theme
echo "Running run_create_project.sh..."
bash "$root/tests/run_create_project.sh" "$test_project" "$test_theme" "$root/tests/projects"

# Check if the template file was created
if [[ ! -f "$template_file" ]]; then
    echo "Test Failed: template_default.html not found in the test project directory."
    exit 1
fi

# Check if the theme was correctly applied
if grep -q "data-theme=\"$test_theme\"" "$template_file"; then
    echo "Test Passed: Theme '$test_theme' correctly applied to template_default.html."
else
    echo "Test Failed: Theme '$test_theme' not found in template_default.html."
    exit 1
fi

echo "Test complete."
