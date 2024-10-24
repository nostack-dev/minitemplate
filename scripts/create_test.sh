#!/bin/bash

# Ensure a test name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <test_name>"
    exit 1
fi

# Define the test script name
test_name="test_$1.sh"

# Ensure the test script doesn't already exist
if [ -f "$test_name" ]; then
    echo "Error: $test_name already exists."
    exit 1
fi

# Create the new test script
cat > "../tests/$test_name" <<EOL
#!/bin/bash
# Test script for $1 with detailed output and no prompts
# Marker to indicate whether this test is implemented
implemented=false

echo -e "\n--- Starting test: $1 ---"

# Flag to track test success
TEST_PASSED=true

# Color definitions for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Find the project root directory (assuming the script is located in ./tests)
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="\$(cd "\${SCRIPT_DIR}/.." && pwd)"

# Setup: Copy necessary files from the project root directory
echo -e "\n--- Setting up environment for $1 ---"
if [ ! -f "\${PROJECT_ROOT}/scripts/generate_site.sh" ] || [ ! -f "\${PROJECT_ROOT}/templates/template_default.html" ]; then
    echo -e "\${RED}✖ Error: Required files (generate_site.sh or template_default.html) are missing in the project.\${NC}"
    TEST_PASSED=false
    exit 1
fi
cp -rf "\${PROJECT_ROOT}/scripts/generate_site.sh" "\${PROJECT_ROOT}/templates/template_default.html" . || {
    echo -e "\${RED}✖ Failed to copy required files for the test from the project root.\${NC}"
    TEST_PASSED=false
}

# Example test command (with no interactive prompts)
echo -e "\n--- Running test command for $1 ---"
if ./generate_site.sh > generate_output.log 2>&1; then
    echo -e "\${GREEN}✔ Test command executed successfully.\${NC}"
else
    echo -e "\${RED}✖ Test command failed.\${NC}"
    echo -e "\n--- Command output ---"
    cat generate_output.log
    TEST_PASSED=false
fi

# Check if the expected output exists
echo -e "\n--- Checking if expected output (index.html) was generated ---"
if [ -f "./index.html" ]; then
    echo -e "\${GREEN}✔ Test passed: index.html was generated.\${NC}"
else
    echo -e "\${RED}✖ Test failed: index.html was not generated.\${NC}"
    TEST_PASSED=false
fi

# Final test result
if [ "\$TEST_PASSED" = true ]; then
    echo -e "\${GREEN}✔ All checks passed for $1.\${NC}"
    exit 0
else
    echo -e "\${RED}✖ Some checks failed for $1.\${NC}"
    exit 1
fi
EOL

# Make the new test script executable
chmod +x "../tests/$test_name"

# Confirm creation
echo "New test script created: $test_name"
