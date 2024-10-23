#!/bin/bash

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
    "./tests/*.html"              # Exclude all .html files dynamically in the tests fol    
    "./tests/*.md"                # Exclude all .md
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
            echo "${prefix}$(basename "$item")/"
            print_directory "$item" "$prefix    "
        elif [ -f "$item" ]; then
            # Print file in tree format
            echo "${prefix}$(basename "$item")"

            # Print the contents of the file
            echo "Contents of $(basename "$item"):"
            cat "$item"
            echo "------------------------"
        fi
    done
}

# Run the script starting from the current directory
print_directory "." ""
