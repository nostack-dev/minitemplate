#!/bin/bash

# Check if serve.sh exists
if [ -f "./serve.sh" ]; then
  # Run serve.sh
  bash ./serve.sh
else
  echo "Error: serve.sh not found in the current directory."
  exit 1
fi
