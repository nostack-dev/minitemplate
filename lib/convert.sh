#!/bin/bash

# Get the absolute path of the script directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the source and output directories statically in ./lib
source_dir="$script_dir/input"
output_dir="$script_dir/output"
custom_output_dir="$script_dir/custom_output"

# Create the input, output, and custom_output directories if they don't exist
mkdir -p "$source_dir"
mkdir -p "$output_dir"
mkdir -p "$custom_output_dir"

# Check if the second argument (custom HTML) is provided
if [[ -n "$2" ]]; then
  # Use the custom_output directory for custom HTML input
  output_dir="$custom_output_dir"
  component_name="${1,,}custom"  # Append 'custom' to the component name
  custom_html="$2"

  # Create the new filename with "customComponent" appended
  new_filename="${component_name}Component.html"

  # Wrap the provided custom HTML with <div> and <script> stub
  cat <<EOF > "$output_dir/$new_filename"
<div id="${component_name}Component">
  $custom_html
  <script>
    (function() {
      // Empty stub for immediate function
    })();
  </script>
</div>
EOF

  echo "Created $new_filename in $output_dir from custom HTML"
  exit 0
fi

# Default behavior: process files from the input directory
files_to_gather=(accordion.html alert.html artboard.html avatar.html badge.html bottomnavigation.html breadcrumbs.html
button.html buttonnavigation.html card.html carousel.html chatbubble.html checkbox.html code.html collapse.html
countdown.html datainput.html diff.html divider.html drawer.html dropdown.html fileinput.html footer.html hero.html
indicator.html joingroupitems.html kbh.html link.html loading.html mask.html menu.html modal.html navbar.html
navigation.html pagination.html phone.html progress.html radialprogress.html radio.html range.html rating.html
select.html skeleton.html stack.html stat.html steps.html swap.html tab.html table.html textarea.html textinput.html
themecontroller.html timeline.html toast.html toggle.html tooltip.html window.html)

# Loop over the files to gather and create new files in the output directory
for file in "${files_to_gather[@]}"; do
  if [[ -f "$source_dir/$file" ]]; then
    filename=$(basename "$file" .html)
    new_filename="${filename,,}Component.html"

    # Wrap the content from the input file with <div> and <script> stub
    cat <<EOF > "$output_dir/$new_filename"
<div id="${filename,,}Component">
  $(cat "$source_dir/$file")
  <script>
    (function() {
      // Empty stub for immediate function
    })();
  </script>
</div>
EOF

    echo "Created $new_filename in $output_dir from $file"
  fi
done

echo "All components have been created and saved in the '$output_dir' directory."
