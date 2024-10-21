#!/bin/bash
# Test Print Script

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cp print.sh README.md template.html index.html "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

# Run the test
./print.sh > output.txt

for file in README.md template.html index.html; do
    if grep -q "Contents of ./$file" output.txt; then
        echo "Test passed: $file is included in the print output"
    else
        echo "Test failed: $file is missing from the print output"
        exit 1
    fi
done

# Clean up
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up."
