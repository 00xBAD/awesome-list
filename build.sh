#!/bin/bash

# Define the output README.md file and the header/footer files
OUTPUT_FILE="README.md"
HEADER_FILE="categories/_HEADER.md"
FOOTER_FILE="categories/_FOOTER.md"

# Check if the header and footer files exist
if [[ ! -f "$HEADER_FILE" ]]; then
  echo "Error: $HEADER_FILE does not exist."
  exit 1
fi

if [[ ! -f "$FOOTER_FILE" ]]; then
  echo "Error: $FOOTER_FILE does not exist."
  exit 1
fi

echo "Building $OUTPUT_FILE..."

# Check if the output file exists and empty it if it does
if [[ -f "$OUTPUT_FILE" ]]; then
  > "$OUTPUT_FILE"
  echo "Cleared $OUTPUT_FILE"
fi

# Start the output README.md file with the header content
cat "$HEADER_FILE" >"$OUTPUT_FILE"
echo "" >>"$OUTPUT_FILE"

# Generate a table of contents
echo "## Table of Contents" >>"$OUTPUT_FILE"
echo "" >>"$OUTPUT_FILE"

# Loop through each markdown file in the categories directory
for file in categories/*.md; do
  # Check if the file exists and is not the header or footer
  if [[ -f "$file" && "$file" != "$HEADER_FILE" && "$file" != "$FOOTER_FILE" ]]; then
    # Extract the first line of the file to use as the title
    title=$(head -n 1 "$file")
    # Remove leading '#' characters and trim whitespace
    title=$(echo "$title" | sed 's/^#* *//' | tr -d '\r\n')
    # Convert title to lowercase, replace spaces with hyphens.
    escaped_title=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    # Remove special characters
    escaped_title=$(echo "$escaped_title" | tr -cd '[:alnum:]-')
    # Add the title to the table of contents with a link to the section
    echo "- [$title](#$escaped_title)" >>"$OUTPUT_FILE"
  fi
done

# Add a final separator
{
  echo ""
  echo "---"
  echo ""
} >>"$OUTPUT_FILE"

# Flag to check if any category files were found
found_files=false

# Loop through each markdown file in the categories directory
for file in categories/*.md; do
  # Check if the file exists and is not the header or footer
  if [[ -f "$file" && "$file" != "$HEADER_FILE" && "$file" != "$FOOTER_FILE" ]]; then
    # If we found at least one file, set the flag
    found_files=true

    # Append the full content of the markdown file
    {
      cat "$file"
      echo ""
      echo "---"
      echo ""
    } >>"$OUTPUT_FILE"
  fi
done

# Check if no category files were found
if ! $found_files; then
  echo "Warning: No category files found in 'categories' directory."
fi

# Add the footer content and a final separator
cat "$FOOTER_FILE" >>"$OUTPUT_FILE"

echo "Compiled $OUTPUT_FILE successfully!"
