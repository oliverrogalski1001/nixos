#!/usr/bin/env bash

# Directory to search for PDF files
SEARCH_DIR="$HOME"

# Find all PDF files and store them in an array
mapfile -t PDF_FILES < <(fd -e pdf . "$SEARCH_DIR")

# Use rofi to display the list of PDF files and get user selection
SELECTED_PDF=$(printf '%s\n' "${PDF_FILES[@]}" | rofi -dmenu -i -p "Select a PDF file")

# Check if a file was selected
if [ -n "$SELECTED_PDF" ]; then
  # Open the selected PDF file with the default PDF viewer
  zathura "$SELECTED_PDF"
else
  echo "No file selected."
fi
