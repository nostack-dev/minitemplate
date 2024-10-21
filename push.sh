#!/bin/bash

# Run the `git push` command
git push

# Run the post-push tests script after pushing changes
if [ $? -eq 0 ]; then
  echo "Git push successful. Running tests..."
  ./run_tests.sh
else
  echo "Git push failed. Tests will not run."
fi
