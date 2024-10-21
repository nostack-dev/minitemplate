#!/bin/bash

# Install the pre-push hook
HOOK_DIR=".git/hooks"
HOOK_FILE="pre-push"

echo "Installing pre-push hook..."
mkdir -p "$HOOK_DIR"
cp hooks/pre-push "$HOOK_DIR/$HOOK_FILE"
chmod +x "$HOOK_DIR/$HOOK_FILE"
echo "Pre-push hook installed successfully."
