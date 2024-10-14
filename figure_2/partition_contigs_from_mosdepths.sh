#!/bin/bash

# Description:
# This script processes gzipped bed files for different barcodes and types.
# It uses a nested loop to iterate over specified barcodes and types, and for each combination,
# it performs partitioning of the data using qsvlite (or an equivalent CSV processing tool).
# The resulting files are saved with names corresponding to each barcode and type.

# Array of barcodes
barcodes=("barcode05" "barcode06" "barcode07")

# Array of types
types=("sequenced" "unblocked")

# Loop through each barcode
for barcode in "${barcodes[@]}"; do
    # Loop through each type
    for type in "${types[@]}"; do
        # Define the input file name based on current barcode and type
        input_file="all_${barcode}.${type}.fastq.per-base.bed.gz"
        
        # Check if the input file exists
        if [[ -f "$input_file" ]]; then
            # Define the output file name
            output_file="all_data_${barcode}_mosdepth_beds"
            
            # Run the command with qsvlite and other processing
            zcat "$input_file" | qsvlite partition --filename "{}.${barcode}.${type}.per-base.tsv" -d "\t" --no-headers 1 "$output_file"
            
            for file in "$output_file"/*.tsv; do
                mv -- "$file" "${file%.tsv}.bed"
            done

            echo "Processed $input_file and renamed files in $output_dir"
        else
            echo "File $input_file does not exist, skipping..."
        fi
    done
done

