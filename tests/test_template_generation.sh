#!/bin/bash
# Test Template Generation Script

# Create a temporary directory
cp ../generate.sh ../template.html ../headerComponent.html ../contentComponent.html ../sidebarComponent.html ../footerComponent.html ../tests

# Provide a default title for the test
export PAGE_TITLE="Test Page Title"

# Debug: check if footerComponent.html exists
if [ -f "footerComponent.html" ]; then
    echo "Debug: footerComponent.html found."
else
    echo "Debug: footerComponent.html is missing."
fi

# Run the test without prompting for the title
echo "$PAGE_TITLE" | ./generate.sh "light"

# Check if index.html was generated
if [ -f "index.html" ]; then
    echo "Test passed: index.html exists"
else
    echo "Test failed: index.html does not exist"
    exit 1
fi

if grep -q 'data-theme="light"' "index.html"; then
    echo "Test passed: index.html has correct theme"
else
    echo "Test failed: Theme not applied correctly in index.html"
    exit 1
fi

if grep -q '<div id="headerComponent"' "index.html"; then
    echo "Test passed: headerComponent included in index.html"
else
    echo "Test failed: headerComponent missing in index.html"
    exit 1
fi
