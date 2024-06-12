#!/bin/bash

# List of barcodes and their corresponding BED files
declare -A barcode_bed_files=(
    ["barcode01"]="/data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/tst_170_coords_extended.sorted.bed /data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/tst_170_coords_extended.sorted_inverse_complement.bed"
    ["barcode02"]="/data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/tst_fusion_coords_extended.sorted.bed /data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/tst_fusion_coords_extended.sorted_inverse_complement.bed"
    ["barcode03"]="/data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/CancerPanelTargets.sorted.bed /data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/CancerPanelTargets.sorted_inverse_complement.bed"
    ["unclassified"]="/data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/all_targets.merged.sorted.bed /data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/all_targets.sorted_inverse_complement.bed"
    ["barcode05"]="/data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/tst_170_coords_extended.sorted.bed /data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/tst_170_coords_extended.sorted_inverse_complement.bed"
    ["barcode06"]="/data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/tst_fusion_coords_extended.sorted.bed /data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/tst_fusion_coords_extended.sorted_inverse_complement.bed"
    ["barcode07"]="/data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/CancerPanelTargets.sorted.bed /data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/CancerPanelTargets.sorted_inverse_complement.bed"
    ["unclassified_prom"]="/data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/all_targets.merged.sorted.bed /data/projects/rory_says_hi/readfish_update_paper/figures/barcode_paper_nb/table_1/target_beds/all_targets.sorted_inverse_complement.bed"
)

# Function to run mosdepth for a given barcode and bed file
run_mosdepth() {
    local barcode=$1
    IFS=' ' read -r -a bed_files <<< "$2"
    for bed_file in "${bed_files[@]}"; do
        

        echo "Running mosdepth for ${barcode} with ${bed_file}..."
        local bed_basename=$(basename "$bed_file" .bed)

        # Set the output prefix
        local output_prefix="${barcode}_${bed_basename}"
        # Run mosdepth
        mosdepth -m -t 24 --by "${bed_file}" -xn "${output_prefix}" "${barcode}.sorted.bam"

        echo "Finished mosdepth for ${barcode} with ${bed_file}"
    done
}

export -f run_mosdepth

# Export the associative array
export -A barcode_bed_files
# Run all pairings in parallel
for barcode in "${!barcode_bed_files[@]}"; do
    IFS=' ' read -r -a bed_files <<< "${barcode_bed_files[$barcode]}"
    for bed_file in "${bed_files[@]}"; do
        # Run each pairing in parallel
        echo "$barcode $bed_file"
    done
done | parallel --colsep ' ' run_mosdepth {1} {2}
