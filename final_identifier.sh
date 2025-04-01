#!/bin/bash

# Define file paths
protein_file="/gpfs/scratch/hridout/identifier/Proteins_Species_Genes_MakingLabels.txt"
orthogroup_file="/gpfs/scratch/hridout/identifier/Orthogroups_MCL1.5.txt"
output_file="/gpfs/scratch/hridout/identifier/output_with_OG.txt"

# Extract Protein ID, Species, and Orthogroups (assuming order matches between the files)
paste <(awk '{print $1}' "$protein_file") <(awk '{print $2}' "$protein_file") <(cat "$orthogroup_file") | \
awk '{print $1, $3, $2}' > "$output_file"

echo "Output written to $output_file"

