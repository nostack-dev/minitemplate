#!/bin/bash
# Test script for verifying print output

echo -e "\n--- Initializing test: Print Output Validation ---"

# Initialize a flag to track test results
TEST_PASSED=true

# Copy necessary files to the current directory
echo -e "\n--- Copying files for the test ---"
cp -r ../print.sh ../README.md ../lib/templates/template.html ../index.html . || { echo -e "${RED}✖ Error: Failed to copy required files.${NC}"; TEST_PASSED=false; }

# Run the print.sh script and capture output
./print.sh > output.txt

# Test for the presence of specific files in the output
for file in README.md template.html index.html; do
    echo -e "\n--- Checking print output for $file ---"
    if grep -q "Contents of ./$file" output.txt; then
        echo -e "${GREEN}✔ Test passed: $file is included in the print output.${NC}"
    else
        echo -e "${RED}✖ Test failed: $file is missing from the print output.${NC}"
        TEST_PASSED=false
    fi
done

# Final result for this test script
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN}✔ All files verified in the print output.${NC}"
    exit 0
else
    echo -e "${RED}✖ One or more tests failed in print output validation.${NC}"
    exit 1
fi
