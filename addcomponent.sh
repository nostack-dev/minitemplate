#!/bin/bash

# Define directories
output_dir="./lib/output"
custom_output_dir="./lib/custom_output"

# Check if the regular output directory exists
if [ ! -d "$output_dir" ]; then
    echo "Error: Directory $output_dir not found!"
    exit 1
fi

# Gather regular and (if it exists) custom component lists
regular_components=$(find "$output_dir" -type f -name "*Component.html" | sed 's|.*/||' | sed 's/Component.html//')

# Check if the custom_output directory exists and gather custom components if it does
if [ -d "$custom_output_dir" ]; then
    custom_components=$(find "$custom_output_dir" -type f -name "*Component.html" | sed 's|.*/||' | sed 's/Component.html//')
else
    custom_components=""
fi

# Check if a component name is passed as a parameter
if [ -z "$1" ]; then
    echo "Usage: ./addcomponent.sh [componentName]"
    echo "Example: ./addcomponent.sh button or ./addcomponent.sh buttoncustom"
    echo
    echo "Available components (Regular):"

    # Display regular components in columns
    echo "$regular_components" | xargs -n 3 | awk '{ printf "%-20s %-20s %-20s\n", $1, $2, $3 }'

    if [ -n "$custom_components" ]; then
        echo
        echo "Available components (Custom):"

        # Display custom components in columns if they exist
        echo "$custom_components" | xargs -n 3 | awk '{ printf "%-20s %-20s %-20s\n", $1, $2, $3 }'
    else
        echo
        echo "No custom components found!"
        echo "To create custom components, run: ./lib/convert.sh [customComponentName] '<custom_html>'"
    fi

    # Hint for DaisyUI components
    echo
    echo "See available component designs at: https://daisyui.com/components/"

    exit 1
fi

# Determine if the component is custom
if [[ "$1" == *custom ]]; then
    if [ -d "$custom_output_dir" ]; then
        component="$custom_output_dir/$1Component.html"
    else
        echo "Error: Custom components directory ($custom_output_dir) not found!"
        echo "To create custom components, run: ./lib/convert.sh [customComponentName] '<custom_html>'"
        exit 1
    fi
else
    component="$output_dir/$1Component.html"
fi

# Check if the component file exists
if [ -f "$component" ]; then
    echo "You selected: $component"

    # Copy the selected component to the current directory
    cp "$component" ./
    echo "Copied $component to the current directory."
else
    echo "Component '$1' not found!"
    exit 1
fi
