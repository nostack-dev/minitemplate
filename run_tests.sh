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

# Function to run a single test script
run_test() {
    local test_script="$1"
    $VERBOSE && echo -e "\n### Running \`$test_script\`"

    if bash "$test_script" > /dev/null 2>&1; then
        echo -e "${GREEN}${CHECKMARK} Test passed: $test_script${NC}"
        return 0
    else
        echo -e "${RED}✖ Test failed: $test_script${NC}"
        if [ "$VERBOSE" = true ]; then
            echo -e "\n---\n"
            bash "$test_script"
        fi
        return 1
    fi
}

echo -e "\n## Running Tests\n"

# Copy utility scripts to the tests folder before running the tests
copy_scripts_to_tests

# Find all test scripts dynamically in the ./tests/ directory
test_scripts=( ./tests/test_*.sh )

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
