#!/bin/bash

#SBATCH --job-name=busco_kuderna
#SBATCH --output=/gpfs/projects/RestGroup/helen/busco_kuderna.log
#SBATCH -p extended-96core
#SBATCH --time=160:00:00


# Load necessary modules
module load hts

# Input and output directories
INPUT_DIR="/gpfs/scratch/hridout/Primate_Genome_Annotation_GFF_Files/"
OUTPUT_DIR="/gpfs/scratch/hridout/kuderna_genomes/busco_files"
FASTA_DIR="/gpfs/scratch/hridout/kuderna_genomes/"

# Process each GFF file
for GFF_FILE in ${INPUT_DIR}/*.gff; do
    # Extract just the species name from the annotation file (remove .annotation and extension)
    BASENAME=$(basename "$GFF_FILE" .gff)
    SPECIES_NAME=$(echo "$BASENAME" | sed 's/\.annotation//')  # Remove '.annotation'

    # Match this species name with the corresponding .fna file
    FASTA_FILE="${FASTA_DIR}/${SPECIES_NAME}.fna"  # Adjusted FASTA file path

    # Check if genome FASTA exists
    if [[ ! -f "$FASTA_FILE" ]]; then
        echo "Error: FASTA file $FASTA_FILE does not exist for $SPECIES_NAME!"
        continue
    fi

    # If the FASTA exists, proceed with processing
    echo "Processing $SPECIES_NAME..."
    gffread -g "$FASTA_FILE" \
            -x "${OUTPUT_DIR}/${SPECIES_NAME}_cds.fasta" \
            -y "${OUTPUT_DIR}/${SPECIES_NAME}_protein.fasta" \
            -w "${OUTPUT_DIR}/${SPECIES_NAME}_transcripts.fasta" \
            "$GFF_FILE"
done

