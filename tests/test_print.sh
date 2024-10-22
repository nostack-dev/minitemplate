#!/bin/bash
# Test Print Script

cp ../print.sh ../README.md ../template.html ../index.html ../tests

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
