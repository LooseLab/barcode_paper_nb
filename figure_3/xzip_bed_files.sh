#!/bin/bash

# Set the parent directory containing the subdirectories with .bed files
PARENT_DIR="."

# Find all .bed files within the subdirectories of the parent directory
# and pass them to parallel for compression
find "$PARENT_DIR" -name "*.bed" -type f | parallel 'xz -v -T0 --best {}'

echo "Compression of .bed files is complete."

