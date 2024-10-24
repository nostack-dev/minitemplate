#!/bin/bash

# Color definitions for output similar to the tree command
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# List of files and directories to ignore in tree and content printing
printignore=(
    "CNAME"
    "LICENSE"
    "README.md"
    "CONTRIBUTING.md"
    ".git"
    "objects"
    "print.sh"
    "index.html"
    "lib/components_converted"
    "lib/components_source"
    "projects"
    "tests/output.txt"
    "tests/*.html"
    "tests/*.md"
)

# Function to display help information
show_help() {
    echo -e "${CYAN}Usage: ./print.sh [OPTION]${NC}"
    echo -e "Display the directory structure and optionally print file contents."
    echo -e ""
    echo -e "${CYAN}Options:${NC}"
    echo -e "  ${GREEN}--help${NC}          Show this help message and exit."
    echo -e "  ${GREEN}--tree${NC}           Only display the directory structure, do not print file contents."
    echo -e "  ${GREEN}--hide FILE${NC}      Hide the specified FILE from both the tree and the content output."
    exit 0
}

# Variable to control whether to print file contents or just the tree
PRINT_CONTENTS=true
HIDE_FILE=""

# Parse options
while [[ "$1" != "" ]]; do
    case $1 in
        --help)
            show_help
            ;;
        --tree)
            PRINT_CONTENTS=false
            ;;
        --hide)
            shift
            HIDE_FILE=$1
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            ;;
    esac
    shift
done

# Check if the tree command is installed
if ! command -v tree &> /dev/null; then
    echo -e "${RED}The 'tree' command is not installed.${NC}"
    echo -e "${CYAN}You can install it using one of the following commands based on your system:${NC}"
    echo -e "  ${YELLOW}For Debian/Ubuntu:${NC} sudo apt install tree"
    echo -e "  ${YELLOW}For RedHat/CentOS/Fedora:${NC} sudo yum install tree"
    echo -e "  ${YELLOW}For macOS (with Homebrew):${NC} brew install tree"
    echo -e "  ${YELLOW}For Arch Linux:${NC} sudo pacman -S tree"
    exit 1
fi

# Add the HIDE_FILE to the ignore list if provided
if [[ -n "$HIDE_FILE" ]]; then
    printignore+=("$HIDE_FILE")
fi

# Convert the ignore list to a format tree can use
tree_ignore=$(printf " -I '%s'" "${printignore[@]}")

# Print the directory tree using tree
echo -e "${CYAN}Directory tree:${NC}"
eval "tree -C $tree_ignore"

# If the --tree option is not provided, print the file contents
if [ "$PRINT_CONTENTS" = true ]; then
    # Function to print file contents
    print_file_contents() {
        local dir="$1"
        local prefix="$2"

        # Iterate through all files in the directory
        for item in "$dir"/*; do
            # Check if it's a file and not in the ignore list
            if [ -f "$item" ] && ! [[ "${printignore[*]}" =~ "$(basename "$item")" ]]; then
                # Print file in tree format
                echo -e "${GREEN}${prefix}├── $(basename "$item")${NC}"

                # Print the contents of the file, indented properly
                sed "s/^/${prefix}    /" "$item"
            elif [ -d "$item" ] && ! [[ "$item" =~ components_converted|components_source ]]; then
                # Recurse into subdirectories if present and not ignored
                echo -e "${BLUE}${prefix}├── $(basename "$item")/${NC}"
                print_file_contents "$item" "$prefix    "
            fi
        done
    }

    # Print file contents starting from the current directory
    print_file_contents "." ""
fi
