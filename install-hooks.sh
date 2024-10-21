#!/bin/bash

# Install Git hooks by copying them to the .git/hooks directory
HOOK_DIR=".git/hooks"
HOOK_SOURCE_DIR="./hooks"

mkdir -p "$HOOK_DIR"

for hook in "$HOOK_SOURCE_DIR"/*; do
    HOOK_NAME=$(basename "$hook")
    cp "$hook" "$HOOK_DIR/$HOOK_NAME"
    chmod +x "$HOOK_DIR/$HOOK_NAME"
done

echo "Git hooks installed successfully."
