#!/bin/bash
# Test opening index.html in Chrome (headless mode)

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Creating temporary directory: $TEMP_DIR"
cp index.html "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

# Inform about the action
echo "Opening index.html in Chrome..."

# Convert the path to Windows format
target=$(wslpath -w ./index.html)

# Start Chrome in headless mode using PowerShell
echo "Starting Chrome in headless mode..."
powershell.exe -Command "Start-Process 'chrome.exe' -ArgumentList '--headless', '--disable-gpu', '--remote-debugging-port=9222', 'file://$target'"

# Wait briefly to allow Chrome to start
echo "Waiting for Chrome to start..."
sleep 2  # Adjusted wait time for Chrome to initialize

# Check if Chrome is running using Windows tasklist
if tasklist.exe | grep -q "chrome.exe"; then
    echo -e "${GREEN}Test passed: index.html opened in Chrome${NC}"
else
    echo -e "${RED}Test failed: Chrome did not start${NC}"
    exit 1
fi

# Clean up
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up."
