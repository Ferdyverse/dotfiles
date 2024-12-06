#!/bin/bash

# Define the directory where the modules are located
MODULES_DIR="$HOME/.config/waybar/modules"

# Create an array of full paths of the files in the "modules" directory
FILES=$(find "$MODULES_DIR" -maxdepth 1 -type f)

# Begin the JSON content
JSON_CONTENT="{\"include\":["

# Add the full file paths to the JSON array
for FILE in $FILES; do
  JSON_CONTENT="$JSON_CONTENT\"$FILE\","
done

# Remove the last comma, if present
JSON_CONTENT="${JSON_CONTENT%,}"

# Close the JSON array and the JSON object structure
JSON_CONTENT="$JSON_CONTENT]}"

# Write the content to the modules.jsonc file
echo "$JSON_CONTENT" > "$HOME/.config/waybar/modules.jsonc"

echo "The file modules.jsonc has been created at $HOME/.config/waybar/"
