#!/usr/bin/env bash

#SBATCH --job-name=rep_maskers_ateles
#SBATCH --output=/gpfs/projects/RestGroup/helen/rep_maskers_ateles.log
#SBATCH -p extended-96core
#SBATCH --time=168:00:00
#SBATCH --ntasks=24

module unload busco
module load EDTA


# Set the scratch working directory
SCRATCHDIR=/gpfs/scratch/hridout/$SLURM_JOB_ID
mkdir -p $SCRATCHDIR

# Copy necessary files to the scratch directory
cp /gpfs/projects/RestGroup/helen/Annotation/primate_genome/ateles_geoffroyi/ateles_geoffroyi.fna $SCRATCHDIR

# Change to the scratch directory
cd $SCRATCHDIR

# Run the BuildDatabase and RepeatModeler commands
BuildDatabase -name Ateles_geoffroyi -engine ncbi ateles_geoffroyi.fna 
RepeatModeler -pa 24 -engine ncbi -database Ateles_geoffroyi 2>&1 | tee repeatmodeler.log

# Copy the output files back to the original working directory
cp repeatmodeler.log /gpfs/projects/RestGroup/helen/Annotation/primate_genome/ateles_geoffroyi/
cp -r RM_*/ /gpfs/projects/RestGroup/helen/Annotation/primate_genome/ateles_geoffroyi/


