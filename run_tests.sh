#!/bin/bash

# Color definitions for success and failure
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
CHECKMARK='\u2714' # Checkmark

# Function to clean up old temporary files, but keep test scripts intact
cleanup_tests_directory() {
    echo "Cleaning up old temporary files in the tests directory..."
    # Only remove files that match temporary patterns (e.g., temp_*.html or other temp files)
    rm -f ./tests/temp_*.html 2>/dev/null
    rm -f ./tests/*.log 2>/dev/null # Remove log files if they exist
}

# Function to copy the required utility scripts to the tests directory
copy_scripts_to_tests() {
    echo "Copying required scripts to tests directory..."
    cp ./generate.sh ./tests/
    cp ./createcomponent.sh ./tests/
    cp ./wrapcomponents.sh ./tests/
}

# Function to run a single test script
run_test() {
    local test_script="$1"
    echo "Running $test_script..."

    if bash "$test_script"; then
        echo -e "${GREEN}${CHECKMARK} Test passed: $test_script${NC}"
        return 0
    else
        echo -e "${RED}✖ Test failed: $test_script${NC}"
        return 1
    fi
}

# Clean up temporary files before starting tests
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
        echo -e "${RED}Test script not found: $test_script${NC}"
        ((failed++))
    fi
done

# Summary of results
echo "---------------------------------"
for test_script in "${test_scripts[@]}"; do
    if [ -f "$test_script" ]; then
        echo -e "${GREEN}${CHECKMARK} $test_script${NC}"
    fi
done

if [ "$failed" -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
else
    echo -e "${RED}Some tests failed.${NC}"
fi
echo "---------------------------------"
echo "All tests finished."
