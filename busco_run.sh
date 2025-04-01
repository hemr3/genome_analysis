#!/usr/bin/env bash

#SBATCH --job-name=busco_kuderna
#SBATCH --output=/gpfs/projects/RestGroup/helen/busco_kuderna.log
#SBATCH -p extended-96core
#SBATCH --time=160:00:00

# Modules
module unload genome_annotation/1.0
# Load hts temporarily to extract proteins
module load hts
# Set up directories
SCRATCHDIR=/gpfs/scratch/hridout/$SLURM_JOB_ID mkdir -p "$SCRATCHDIR" 
GFF_DIR=/gpfs/scratch/hridout/Primate_Genome_Annotation_GFF_Files 
FASTA_DIR=/gpfs/scratch/hridout/kuderna_genomes
# Change to the scratch directory
cd "$SCRATCHDIR" || exit 1
# Process GFF files
for gff_file in "$GFF_DIR"/*.gff; do
    # Extract species name
    species_name=$(basename "$gff_file" .annotation.gff) 
    fasta_file="$FASTA_DIR/${species_name}.fna"
    # Check if the corresponding .fna file exists
    if [ -f "$fasta_file" ]; then echo "Processing $species_name..."
        # Extract protein sequences
        protein_file="${species_name}_proteins.faa" gffread -y 
        "$protein_file" -g "$fasta_file" "$gff_file"
        # Unload hts after extracting proteins
        module unload hts module load busco
        # Run BUSCO
        output_name="${species_name}_busco" busco -i "$protein_file" -m 
        proteins -l primates_odb10 -o "$output_name" -f
        # Reload hts for the next file
        module unload busco module load hts else echo "WARNING: No 
        corresponding .fna file found for $species_name. Skipping."
    fi done
# Clean up
module unload hts module unload busco
echo "BUSCO analysis completed."
