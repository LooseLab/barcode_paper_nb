#!/bin/bash

# List of barcodes
barcodes=("barcode01" "barcode02" "barcode03" "unclassified")

# Reference genome for minimap2 (replace with your actual reference file)
reference_genome="/data/refs/hg38.p14.simple.mmi"

# Loop through each barcode

process_barcode() {
    local barcode=$1
    echo "Processing files for ${barcode}..."

    # Use fd to find all .fastq.gz files with the barcode in the name, pipe the list to xargs, then zcat, and pipe to minimap2
    fd -e fastq.gz "${barcode}" -0 | xargs -0 zcat | minimap2 --secondary=no -2 -t 22 -a "$reference_genome" - | samtools sort -@ 4 --write-index -O BAM -T "/data/tmp/sort_barcoded_grid_${barcode}" -o "/data/projects/rory_says_hi/${barcode}.sorted.bam" -

    echo "Finished processing ${barcode}"
}

export -f process_barcode

# Export the variables
export reference_genome

# Run the process_barcode function in parallel for each barcode
parallel process_barcode ::: "${barcodes[@]}"
