#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --mem=132G
#SBATCH --cpus-per-task=4
#SBATCH --time=2:00:00
#SBATCH --partition=short-40core-shared

module load hts

fastqc fastqc SRR30488872.fastq

