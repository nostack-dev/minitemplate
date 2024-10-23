#!/bin/bash
# Test script for index_served with detailed output and no prompts
# Marker to indicate whether this test is implemented
implemented=true

echo -e "\n--- Starting test: index_served ---"

# Flag to track test success
TEST_PASSED=true

# Color definitions for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Ensure we are running inside the ./tests directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Ensure we are running inside the ./tests directory
if [ "$(basename "${SCRIPT_DIR}")" != "tests" ]; then
    echo -e "\n${RED}✖ Error: This script must be run inside the ./tests directory.${NC}"
    TEST_PASSED=false
    exit 1
fi

# Check if the ./public folder exists
echo -e "\n--- Checking if the public directory exists ---"
if [ -d "${PROJECT_ROOT}/public" ]; then
    echo -e "${GREEN}✔ The public directory exists.${NC}"
else
    echo -e "${RED}✖ Test failed: The public directory does not exist.${NC}"
    TEST_PASSED=false
fi

# Check if index.html exists in the ./public folder
echo -e "\n--- Checking if index.html exists in the public directory ---"
if [ -f "${PROJECT_ROOT}/public/index.html" ]; then
    echo -e "${GREEN}✔ Test passed: index.html was found in the public directory.${NC}"
else
    echo -e "${RED}✖ Test failed: index.html was not found in the public directory.${NC}"
    TEST_PASSED=false
fi

# Final test result
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN}✔ All checks passed for index_served.${NC}"
    exit 0
else
    echo -e "${RED}✖ Some checks failed for index_served.${NC}"
    exit 1
fi
