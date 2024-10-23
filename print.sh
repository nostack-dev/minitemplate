#!/bin/bash

# Color definitions for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# List of files and directories to ignore
printignore=(
    "./lib/components_converted"  # Exclude the converted components folder (output folder)
    "./lib/components_source"     # Exclude the source components folder
    "./projects"                  # Exclude the projects directory
    "./tests/*/*"                 # Exclude subfolders inside the tests folder, but keep direct contents
    "./CNAME"                     # Exclude the CNAME file (typically used for custom domains)
    "./LICENSE"                   # Exclude the LICENSE file
    "./README.md"                 # Exclude the README.md file
    "./CONTRIBUTING.md"           # Exclude the CONTRIBUTING.md file
    "./.git"                      # Exclude the .git directory (version control related)
    "./objects"                   # Exclude the objects folder (possibly git objects or build artifacts)
    "./print.sh"                  # Exclude the print.sh script itself
    "./index.html"                # Exclude index.html files in any directory
    "./tests/output.txt"          # Exclude output.txt specifically in the tests folder
    "./tests/*.html"              # Exclude all .html files dynamically in the tests folder
    "./tests/*.md"                # Exclude all .md files
)

# Function to check if a file or directory should be ignored
should_ignore() {
    local item="$1"
    for ignore in "${printignore[@]}"; do
        if [[ "$item" == $ignore* ]]; then
            return 0
        fi
    done
    return 1
}

# Recursive function to print the directory tree and file contents
print_directory() {
    local dir="$1"
    local prefix="$2"

    # Iterate through all items in the directory
    for item in "$dir"/*; do
        # Check if the item is in the ignore list
        if should_ignore "$item" || [[ "$(basename "$item")" == "index.html" ]] || [[ "$(basename "$item")" == "print.sh" ]]; then
            continue
        fi

        # If it's a directory, print and recurse into it
        if [ -d "$item" ]; then
            echo -e "${BLUE}${prefix}$(basename "$item")/${NC}"
            print_directory "$item" "$prefix    "
        elif [ -f "$item" ]; then
            # Print file in tree format
            echo -e "${CYAN}${prefix}$(basename "$item")${NC}"

            # Print the contents of the file
            echo -e "${YELLOW}Contents of $(basename "$item"):${NC}"
            cat "$item"
            echo -e "${RED}------------------------${NC}"
        fi
    done
}

# Run the script starting from the current directory
print_directory "." ""
