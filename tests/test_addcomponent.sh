#!/bin/bash

# Test script for addcomponent.sh

# Define paths
TEST_SCRIPT="./addcomponent.sh"
LIB_DIR="../lib"
TEST_COMPONENT="button"
CUSTOM_TEST_COMPONENT="buttoncustom"
CUSTOM_OUTPUT_DIR="./lib/custom_output"

# 1. Setup: Copy the addcomponent.sh script and lib directory to the test folder
echo "Setting up the test environment..."
cp ../addcomponent.sh ./  # Copy addcomponent.sh to tests directory
cp -r $LIB_DIR ./         # Copy lib directory and all its contents to tests directory

# 2. Test: Running without parameters (should list components)
echo "Test 1: Running addcomponent.sh without parameters to list components"
$TEST_SCRIPT > output.txt 2>&1
if grep -q "Available components (Regular):" output.txt; then
    echo "✔ Test 1 Passed: Components listed successfully."
else
    echo "✖ Test 1 Failed: Components not listed."
fi

# 3. Test: Passing a valid regular component (button)
echo "Test 2: Running addcomponent.sh with a valid regular component"
$TEST_SCRIPT $TEST_COMPONENT > output.txt 2>&1
if grep -q "Copied .*${TEST_COMPONENT}Component.html" output.txt; then
    echo "✔ Test 2 Passed: Component '${TEST_COMPONENT}' copied successfully."
else
    echo "✖ Test 2 Failed: Component '${TEST_COMPONENT}' not copied."
fi

# 4. Test: Skip custom components if the directory is empty or not available
if [ -d "$CUSTOM_OUTPUT_DIR" ] && [ "$(ls -A $CUSTOM_OUTPUT_DIR)" ]; then
    echo "Test 3: Running addcomponent.sh with a valid custom component"
    $TEST_SCRIPT $CUSTOM_TEST_COMPONENT > output.txt 2>&1
    if grep -q "Copied .*${CUSTOM_TEST_COMPONENT}Component.html" output.txt; then
        echo "✔ Test 3 Passed: Custom component '${CUSTOM_TEST_COMPONENT}' copied successfully."
    else
        echo "✖ Test 3 Failed: Custom component '${CUSTOM_TEST_COMPONENT}' not copied."
    fi
else
    echo "Skipping Test 3: Custom components directory ($CUSTOM_OUTPUT_DIR) is either empty or not found."
fi

# 5. Test: Passing an invalid component (with quotes)
echo "Test 4: Running addcomponent.sh with an invalid component"
$TEST_SCRIPT invalidcomponent > output.txt 2>&1
if grep -q "Component 'invalidcomponent' not found!" output.txt; then
    echo "✔ Test 4 Passed: Invalid component error message shown."
else
    echo "✖ Test 4 Failed: Invalid component error message not shown."
fi


