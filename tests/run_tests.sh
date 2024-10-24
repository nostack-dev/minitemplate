#!/bin/bash

# Color definitions for success and failure
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
CHECKMARK='✔' # Checkmark
CROSSMARK='✖' # Crossmark
WARNING='⚠' # Warning

# Verbose flag (default: false)
VERBOSE=false

# Check for verbose flag
while getopts "v" option; do
  case $option in
    v) VERBOSE=true;;
    *) echo -e "${RED}Usage: $0 [-v]${NC}"; exit 1;;
  esac
done

# Summary of results at the beginning
echo -e "\n### Test Start"
echo -e "---------------------------------\n"

# Function to copy the required utility scripts to the tests directory
copy_scripts_to_tests() {
    $VERBOSE && echo -e "\n📄 ${GREEN}Copying required scripts to tests directory...${NC}"

    # Define the source scripts
    local scripts=("generate_site.sh")

    # Loop through each script and copy if it exists
    for script in "${scripts[@]}"; do
        if [ -f "../scripts/$script" ]; then
            cp "../scripts/$script" "./$script" && \
            $VERBOSE && echo -e "${GREEN}✅ Copied $script successfully.${NC}"
        else
            echo -e "${RED}Error: ../scripts/$script not found.${NC}"
            exit 1
        fi
    done
}

# Function to check if a test is implemented
check_for_implemented_marker() {
    local test_script="$1"
    if grep -q "implemented=false" "$test_script"; then
        echo -e "${YELLOW}${WARNING} New test, please implement: $test_script${NC}"
    fi
}

# Function to run a single test script
run_test() {
    local test_script="$1"

    if [ "$VERBOSE" = true ]; then
        echo -e "\n--- Running \`$test_script\` ---"
    fi

    # Check if the test is implemented
    check_for_implemented_marker "$test_script"

    # Execute the test script, capture the result
    if [ "$VERBOSE" = true ]; then
        bash "$test_script" # Output everything in verbose mode
    else
        bash "$test_script" > /dev/null 2>&1 # Suppress output in non-verbose mode
    fi

    # Check the test result
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${CHECKMARK} Test passed: $test_script${NC}"
        return 0
    else
        echo -e "${RED}${CROSSMARK} Test failed: $test_script${NC}"
        return 1
    fi
}

echo -e "\n## Running Tests\n"

# Copy utility scripts to the tests folder before running the tests
copy_scripts_to_tests

# Find all test scripts dynamically in the ./tests/ directory
shopt -s nullglob
test_scripts=( ./test_*.sh )
shopt -u nullglob

# Check if any test scripts were found
if [ ${#test_scripts[@]} -eq 0 ]; then
    echo -e "${RED}No test scripts found in the current directory.${NC}"
    exit 1
fi

$VERBOSE && echo "Found test scripts:"
$VERBOSE && printf " - %s\n" "${test_scripts[@]}"

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
done

# Summary of results
echo -e "\n### Test Summary"
echo -e "---------------------------------"
if [ "$failed" -eq 0 ]; then
    echo -e "${GREEN}${CHECKMARK} All tests passed!${NC}"
else
    echo -e "${RED}${CROSSMARK} Some tests failed.${NC}"
fi
echo -e "---------------------------------"

echo -e "\nTotal Tests Passed: ${GREEN}$passed${NC}"
echo -e "Total Tests Failed: ${RED}$failed${NC}"

echo -e "\nAll tests finished."

# Cleanup: Remove any files copied or generated during the test that aren't test scripts.
[[ "$(basename "$(pwd)")" == "tests" ]] && find . -type f ! -name 'test_*.sh' ! -name 'run_tests.sh' ! -name 'create_test.sh' -delete && find . -type d ! -name '.' -exec rm -rf {} +
exit 0
