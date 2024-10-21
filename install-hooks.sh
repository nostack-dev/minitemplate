#!/bin/bash

# Install the pre-push hook if it doesn't exist
HOOK_DIR=".git/hooks"
HOOK_FILE="pre-push"

if [ ! -f "$HOOK_DIR/$HOOK_FILE" ]; then
  echo "Installing pre-push hook..."
  mkdir -p "$HOOK_DIR"
  cp hooks/pre-push "$HOOK_DIR/"
  chmod +x "$HOOK_DIR/$HOOK_FILE"
  echo "Pre-push hook installed successfully."
else
  echo "Pre-push hook already installed."
fi
