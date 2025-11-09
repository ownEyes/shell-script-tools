#!/bin/bash

# This script removes all files with "Zone.Identifier" in their name under a specified directory.

# Usage: ./remove_zone_identifier.sh /path/to/target/directory

# Exit on error
set -e

# Check if a directory path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/directory"
  exit 1
fi

TARGET_DIR="$1"

# Use find to locate files with "Zone.Identifier" in the name and delete them
find "$TARGET_DIR" -type f -name "*Zone.Identifier*" -print -delete
echo "Removed all files with 'Zone.Identifier' in their name from $TARGET_DIR."