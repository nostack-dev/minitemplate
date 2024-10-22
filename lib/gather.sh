#!/bin/bash

# Define the output file
output_file="all_components.html"

# Clear the output file before starting the gather process
> "$output_file"

# Define the list of files to gather
files_to_gather=(
  accordion.html alert.html artboard.html avatar.html badge.html bottomnavigation.html breadcrumbs.html browser.html
  button.html buttonnavigation.html card.html carousel.html chatbubble.html checkbox.html code.html collapse.html
  countdown.html datainput.html diff.html divider.html drawer.html dropdown.html fileinput.html footer.html hero.html
  indicator.html joingroupitems.html kbh.html link.html loading.html mask.html menu.html modal.html navbar.html
  navigation.html pagination.html phone.html progress.html radialprogress.html radio.html range.html rating.html
  select.html skeleton.html stack.html stat.html steps.html swap.html tab.html table.html textarea.html
  textinput.html themecontroller.html timeline.html toast.html toggle.html tooltip.html window.html
)

# Concatenate only the specified .html files with separators and save to the output file
for file in "${files_to_gather[@]}"; do
  if [[ -f "$file" ]]; then  # Check if the file exists
    echo "##########" >> "$output_file"  # Add the separator without filename
    cat "$file" >> "$output_file"        # Add the content of the file
    echo -e "\n" >> "$output_file"       # Add a newline after the content
  fi
done

# Add the final separator at the end of the file
echo "##########" >> "$output_file"

echo "All components gathered into $output_file."
