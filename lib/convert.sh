#!/bin/bash

# Define the source directory (daisyUI folder) and output directory
source_dir="./input"
output_dir="./output"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Define the list of files to gather from the daisyUI folder
files_to_gather=(
  accordion.html alert.html artboard.html avatar.html badge.html bottomnavigation.html breadcrumbs.html browser.html
  button.html buttonnavigation.html card.html carousel.html chatbubble.html checkbox.html code.html collapse.html
  countdown.html datainput.html diff.html divider.html drawer.html dropdown.html fileinput.html footer.html hero.html
  indicator.html joingroupitems.html kbh.html link.html loading.html mask.html menu.html modal.html navbar.html
  navigation.html pagination.html phone.html progress.html radialprogress.html radio.html range.html rating.html
  select.html skeleton.html stack.html stat.html steps.html swap.html tab.html table.html textarea.html
  textinput.html themecontroller.html timeline.html toast.html toggle.html tooltip.html window.html
)

# Loop over the files to gather and create new files for each one in the output directory
for file in "${files_to_gather[@]}"; do
  if [[ -f "$source_dir/$file" ]]; then  # Check if the file exists in the daisyUI folder
    # Get the filename without the extension
    filename=$(basename "$file" .html)

    # Create the new filename with "Component" at the end, and save it to the output directory
    new_filename="${filename,,}Component.html"  # Lowercase filename with "Component" appended

    # Wrap the component with <div> and <script> stub
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
