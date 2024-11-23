#!/bin/bash
action=$1
shift

case $action in
  1) # List all files and directories
    ls -a ;;
  
  2) # Create new file
    touch "$1" && echo "Created file: $1" ;;
  
  3) # Delete existing file
    if [ -f "$1" ]; then
      rm "$1" && echo "Deleted file: $1"
    else
      echo "Error: $1 not found"
    fi ;;
  
  4) # Rename file
    if [ -f "$1" ]; then
      mv "$1" "$2" && echo "Renamed $1 to $2"
    else
      echo "Error: $1 not found"
    fi ;;
  
  5) # Search file
    find . -name "$1" ;;
  
  6) # Get file details
    stat "$1" ;;
  
  7) # View file content
    if [ -f "$1" ]; then
      cat "$1"
    else
      echo "Error: $1 not found"
    fi ;;
  
  8) # Sort file content
    if [ -f "$1" ]; then
      sort "$1" -o "$1" && echo "Sorted content in $1"
    else
      echo "Error: $1 not found"
    fi ;;
  
  9) # List files with specific extension
    ls *"$1" 2>/dev/null || echo "No files found with extension $1" ;;
  
  10) # Encrypt file (Caesar Cipher example with shift 3)
    if [ -f "$1" ]; then
      tr 'A-Za-z' 'D-ZA-Cd-za-c' < "$1" > "$1.encrypted" && echo "Encrypted file saved as $1.encrypted"
    else
      echo "Error: $1 not found"
    fi ;;
  
  11) # Remove blank spaces in a file
    if [ -f "$1" ]; then
      sed -i 's/[[:space:]]\+$//' "$1" && echo "Removed blank spaces from $1"
    else
      echo "Error: $1 not found"
    fi ;;
  
  12) # Display last modification time
    if [ -f "$1" ]; then
      stat -c %y "$1"
    else
      echo "Error: $1 not found"
    fi ;;

  13) # Compress file using gzip
    if [ -f "$1" ]; then
      gzip "$1" && echo "$1 compressed to $1.gz"
    else
      echo "Error: $1 not found"
    fi ;;
  
  14) # Remove duplicate files based on content
    find . -type f -exec sha256sum {} + | sort | uniq -w 64 -d | while read hash file; do
      # Get all the files with the same hash (duplicates)
      duplicates=$(find . -type f -exec sha256sum {} + | grep "^$hash" | awk '{print $2}')
      first_file=true
      for duplicate in $duplicates; do
        if [ "$first_file" = true ]; then
          first_file=false
          continue  # Keep the first file as the original
        fi
        rm "$duplicate" && echo "Removed duplicate file: $duplicate"
      done
    done ;;

  15) # Calculate file size in different units
    if [ -f "$1" ]; then
      fileSizeBytes=$(stat --format="%s" "$1")
      fileSizeKb=$(echo "scale=2; $fileSizeBytes / 1024" | bc)
      fileSizeMb=$(echo "scale=2; $fileSizeKb / 1024" | bc)
      echo "Size of $1: $fileSizeBytes bytes, $fileSizeKb KB, $fileSizeMb MB."
    else
      echo "Error: $1 not found."
    fi ;;

  *) echo "Invalid action";;
esac
