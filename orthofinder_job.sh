#!/bin/bash
#SBATCH --job-name=orthofinder_run
#SBATCH --partition=extended-96core
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --time=168:00:00
#SBATCH --output=/gpfs/scratch/hridout/orthofinder_%j.log


module load orthofinder  # Load OrthoFinder (adjust this if module systems differ)

orthofinder -f /gpfs/scratch/hridout/protein_fastas/ -I 1.5 -o /gpfs/scratch/hridout/orthofinder_res/


