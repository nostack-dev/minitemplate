
#!/bin/bash

# Test script for addcomponent.sh
# Unified output format with consistent test messaging

# Define paths
TEST_SCRIPT="./addcomponent.sh"
LIB_DIR="../lib"
TEST_COMPONENT="button"
CUSTOM_TEST_COMPONENT="buttoncustom"
CUSTOM_OUTPUT_DIR="./lib/custom_output"

# 1. Setup: Copy the addcomponent.sh script and lib directory to the test folder
echo -e "\n--- Setting up test environment ---"
cp ../addcomponent.sh ./  # Copy addcomponent.sh to tests directory
cp -r $LIB_DIR ./         # Copy lib directory and all its contents to tests directory

# 2. Test: Running without parameters (should list components)
echo -e "\n--- Test 1: Running addcomponent.sh without parameters ---"
$TEST_SCRIPT > output.txt 2>&1
if grep -q "Available components (Regular):" output.txt; then
    echo -e "${GREEN}✔ Test 1 Passed:${NC} Components listed successfully."
else
    echo -e "${RED}✖ Test 1 Failed:${NC} Components not listed."
fi

# 3. Test: Passing a valid regular component (button)
echo -e "\n--- Test 2: Running addcomponent.sh with a valid regular component ---"
$TEST_SCRIPT $TEST_COMPONENT > output.txt 2>&1
if grep -q "Copied .*${TEST_COMPONENT}Component.html" output.txt; then
    echo -e "${GREEN}✔ Test 2 Passed:${NC} Component '${TEST_COMPONENT}' copied successfully."
else
    echo -e "${RED}✖ Test 2 Failed:${NC} Component '${TEST_COMPONENT}' not copied."
fi

# 4. Test: Skip custom components if the directory is empty or not available
if [ -d "$CUSTOM_OUTPUT_DIR" ] && [ "$(ls -A $CUSTOM_OUTPUT_DIR)" ]; then
    echo -e "\n--- Test 3: Running addcomponent.sh with a valid custom component ---"
    $TEST_SCRIPT $CUSTOM_TEST_COMPONENT > output.txt 2>&1
    if grep -q "Copied .*${CUSTOM_TEST_COMPONENT}Component.html" output.txt; then
        echo -e "${GREEN}✔ Test 3 Passed:${NC} Custom component '${CUSTOM_TEST_COMPONENT}' copied successfully."
    else
        echo -e "${RED}✖ Test 3 Failed:${NC} Custom component '${CUSTOM_TEST_COMPONENT}' not copied."
    fi
else
    echo -e "${YELLOW}⚠ Skipping Test 3:${NC} Custom components directory ($CUSTOM_OUTPUT_DIR) is either empty or not found."
fi

# 5. Test: Passing an invalid component (with quotes)
echo -e "\n--- Test 4: Running addcomponent.sh with an invalid component ---"
$TEST_SCRIPT invalidcomponent > output.txt 2>&1
if grep -q "Component 'invalidcomponent' not found!" output.txt; then
    echo -e "${GREEN}✔ Test 4 Passed:${NC} Invalid component error message shown."
else
    echo -e "${RED}✖ Test 4 Failed:${NC} Invalid component error message not shown."
fi
