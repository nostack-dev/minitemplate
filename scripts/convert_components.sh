#!/bin/bash

# Get the absolute path of the script directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the source and output directories located in root/lib/
source_dir="$script_dir/../components/source"
output_dir="$script_dir/../components/converted"
custom_output_dir="$script_dir/../components/custom"

# Create the components_source, components_converted, and components_custom directories if they don't exist
mkdir -p "$source_dir"
mkdir -p "$output_dir"
mkdir -p "$custom_output_dir"

# Check if the second argument (custom HTML) is provided
if [[ -n "$2" ]]; then
  # Use the custom directory for custom HTML input
  output_dir="$custom_output_dir"
  component_name="${1,,}"
  custom_html="$2"

  new_filename="${component_name}.html"

  # Wrap the provided custom HTML with <div> and <script> stub
  cat <<EOF > "$output_dir/$new_filename"
<div id="${component_name}">
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

# Default behavior: process files from the components_source directory
files_to_gather=(accordion.html alert.html artboard.html avatar.html badge.html bottomnavigation.html breadcrumbs.html
button.html buttonnavigation.html card.html carousel.html chatbubble.html checkbox.html code.html collapse.html
countdown.html datainput.html diff.html divider.html drawer.html dropdown.html fileinput.html footer.html hero.html
indicator.html joingroupitems.html kbh.html link.html loading.html mask.html menu.html modal.html navbar.html
navigation.html pagination.html phone.html progress.html radialprogress.html radio.html range.html rating.html
select.html skeleton.html stack.html stat.html steps.html swap.html tab.html table.html textarea.html textinput.html
themecontroller.html timeline.html toast.html toggle.html tooltip.html window.html)

# Loop over the files to gather and create new files in the components_converted directory
for file in "${files_to_gather[@]}"; do
  if [[ -f "$source_dir/$file" ]]; then
    filename=$(basename "$file" .html)
    new_filename="${filename,,}.html"

    # Wrap the content from the input file with <div> and <script> stub
    cat <<EOF > "$output_dir/$new_filename"
<div id="${filename,,}">
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
