#!/bin/bash
# Test script for Template Generation with unified output

echo -e "\n--- Initializing test: Template Generation ---"

# Initialize a flag to track test results
TEST_PASSED=true

# Copy necessary files to the current directory
echo -e "\n--- Copying template files for the test ---"
cp -r ../generate.sh ../template.html ../headerComponent.html ../contentComponent.html ../sidebarComponent.html ../footerComponent.html . || { echo -e "${RED}✖ Error: Failed to copy required files.${NC}"; TEST_PASSED=false; }

# Provide a default title for the test
export PAGE_TITLE="Test Page Title"

# Debug: check if footerComponent.html exists
echo -e "\n--- Checking component files ---"
if [ -f "footerComponent.html" ]; then
    echo -e "${GREEN}✔ footerComponent.html found.${NC}"
else
    echo -e "${RED}✖ footerComponent.html is missing.${NC}"
    TEST_PASSED=false
fi

# Check if the template file exists before running
if [ ! -f "template.html" ]; then
    echo -e "${RED}✖ Error: Template file 'template.html' not found.${NC}"
    TEST_PASSED=false
else
    # Run the test for template generation with the light theme
    echo "$PAGE_TITLE" | ./generate.sh "light"

    # Check if index.html was generated
    echo -e "\n--- Checking generated output ---"
    if [ -f "index.html" ]; then
        echo -e "${GREEN}✔ Test passed: index.html exists.${NC}"
    else
        echo -e "${RED}✖ Test failed: index.html does not exist.${NC}"
        TEST_PASSED=false
    fi

    # Check if the correct theme is applied in the generated file
    if grep -q 'data-theme="light"' "index.html"; then
        echo -e "${GREEN}✔ Test passed: index.html has correct theme.${NC}"
    else
        echo -e "${RED}✖ Test failed: Theme not applied correctly in index.html.${NC}"
        TEST_PASSED=false
    fi

    # Check if headerComponent is included in index.html
    if grep -q '<div id="headerComponent"' "index.html"; then
        echo -e "${GREEN}✔ Test passed: headerComponent included in index.html.${NC}"
    else
        echo -e "${RED}✖ Test failed: headerComponent missing in index.html.${NC}"
        TEST_PASSED=false
    fi
fi

# Final result for this test script
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN}✔ All checks passed for template generation.${NC}"
    exit 0
else
    echo -e "${RED}✖ One or more tests failed in template generation.${NC}"
    exit 1
fi
