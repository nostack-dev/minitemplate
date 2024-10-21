#!/bin/bash

# Color definitions for success and failure
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
CHECKMARK='✔' # Checkmark

# Verbose flag (default: false)
VERBOSE=false

# Check for verbose flag
while getopts "v" option; do
  case $option in
    v) VERBOSE=true;;
    *) echo "Usage: $0 [-v]"; exit 1;;
  esac
done

# Summary of results at the beginning
echo -e "\n### Test Start"
echo -e "---------------------------------\n"

# Function to clean up old temporary files, but keep test scripts intact
cleanup_tests_directory() {
    $VERBOSE && echo -e "\n---------------------------------\n🧹 ${GREEN}Cleaning up old temporary files in the tests directory...${NC}"
    # Only remove files that match temporary patterns (e.g., temp_*.html or other temp files)
    rm -f ./tests/temp_*.html 2>/dev/null
    rm -f ./tests/*.log 2>/dev/null # Remove log files if they exist
}

# Function to copy the required utility scripts to the tests directory
copy_scripts_to_tests() {
    $VERBOSE && echo -e "\n📄 ${GREEN}Copying required scripts to tests directory...${NC}"
    cp ./generate.sh ./tests/
    cp ./createcomponent.sh ./tests/
    cp ./wrapcomponents.sh ./tests/
    mkdir -p ./tests/wrapped
    if [ -d "./wrapped" ]; then
        $VERBOSE && echo -e "📂 ${GREEN}Copying wrapped components to ./tests/wrapped/...${NC}"
        cp -r ./wrapped/* ./tests/wrapped/
    fi
}

# Function to clean up the utility scripts from the tests directory after running the tests
cleanup_copied_scripts() {
    $VERBOSE && echo -e "\n🗑️ ${GREEN}Cleaning up copied utility scripts from tests directory...${NC}"
    rm -f ./tests/generate.sh
    rm -f ./tests/createcomponent.sh
    rm -f ./tests/wrapcomponents.sh
}

# Function to run a single test script
run_test() {
    local test_script="$1"
    if [ "$VERBOSE" = true ]; then
        echo -e "\n### Running \`$test_script\`"
        bash "$test_script"
    fi

    if bash "$test_script" > /dev/null 2>&1; then
        echo -e "${GREEN}${CHECKMARK} Test passed: $test_script${NC}"
        return 0
    else
        echo -e "${RED}✖ Test failed: $test_script${NC}"
        return 1
    fi
}

# Clean up temporary files before starting tests
echo -e "\n## Running Tests\n"
cleanup_tests_directory

# Copy utility scripts to the tests folder before running the tests
copy_scripts_to_tests

# Add to the list of test scripts to run
test_scripts=(
    "./tests/test_component_creation.sh"
    "./tests/test_template_generation.sh"
    "./tests/test_wrap_components.sh"
    "./tests/test_print.sh"
    "./tests/test_invalid_component_references.sh"
)

# Initialize counters for passed and failed tests
passed=0
failed=0

# Run each test script
for test_script in "${test_scripts[@]}"; do
    if [ -f "$test_script" ]; then
        if run_test "$test_script"; then
            ((passed++))
        else
            ((failed++))
        fi
    else
        $VERBOSE && echo -e "${RED}Test script not found: $test_script${NC}"
        ((failed++))
    fi
    $VERBOSE && echo -e "\n---"
done

# Clean up copied utility scripts after running the tests
cleanup_copied_scripts

# Summary of results
echo -e "\n### Test Summary"
echo -e "---------------------------------"
if [ "$failed" -eq 0 ]; then
    echo -e "${GREEN}${CHECKMARK} All tests passed!${NC}"
else
    echo -e "${RED}Some tests failed.${NC}"
fi
echo -e "---------------------------------"

echo -e "\nTotal Tests Passed: ${GREEN}$passed${NC}"
echo -e "Total Tests Failed: ${RED}$failed${NC}"

echo -e "\nAll tests finished."

exit 0
