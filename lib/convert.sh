#!/bin/bash

# Loop through all .html files that do not contain "Component"
for file in *.html; do
  if [[ "$file" != *"Component"* ]]; then
    # Create the new filename
    new_filename="${file%.html}Component.html"

    # Create the new content structure
    echo "<div id=\"${file%.html}Component\">" > "$new_filename"
    cat "$file" >> "$new_filename"
    echo "  <script>" >> "$new_filename"
    echo "    (function() {" >> "$new_filename"
    echo "      // Empty stub for immediate function" >> "$new_filename"
    echo "    })();" >> "$new_filename"
    echo "  </script>" >> "$new_filename"
    echo "</div>" >> "$new_filename"
  fi
done

echo "Component files created successfully."
