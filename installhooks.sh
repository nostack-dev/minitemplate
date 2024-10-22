#!/bin/bash

# Define the directory for Git hooks and the new pre-push hook file
HOOK_DIR=".git/hooks"
HOOK_FILE="pre-push"

# Ensure the hooks directory exists
mkdir -p "$HOOK_DIR"

# Create a new pre-push hook file
echo "Installing new pre-push hook..."
cat <<EOL > "$HOOK_DIR/$HOOK_FILE"
#!/bin/bash

# Run the test script before pushing
./run_tests.sh

# If tests fail, abort the push
if [ \$? -ne 0 ]; then
    echo "Tests failed. Aborting push."
    exit 1
fi
EOL

# Make the hook executable
chmod +x "$HOOK_DIR/$HOOK_FILE"

# Remove the old pre-push hook, if it exists, and rename the new one
rm -f "$HOOK_DIR/pre-push"
mv "$HOOK_DIR/$HOOK_FILE" "$HOOK_DIR/pre-push"

echo "New pre-push hook installed successfully."
