# genome_analysis
Code scripts that are useful for dealing with genetic information + analysis thereof

### addeof.py
  Adds missing EOF markers to the end of genetic files. Drawn from online scripts with minor adjustments. Requires a BAM or BGZF file.

### bamToFasta.txt
  Conversion of BAM genome files to FASTA files. Requires a BAM file and chromosomal coordinates.

### bedToFasta.txt
  Conversion of BED file to FASTA file. Requires a BED file and BEDTools.

### busco_run.sh
  Runs the BUSCO quality assurance algorithm to assess genome quality. Requires GFF files, FASTA files, BUSCO algorithm.

### consensus-sequencing.txt
  Small section of script that generates a consensus VCF file from a FASTA. Requires FASTA files and chromosome positions.

### createFastaheaders.sh
  If a FASTA file has incorrect or far too long headers, this script can be used to adjust the file. Short code snippet. Requires a FASTA file. 

### denovoRepeat_identification.sh
  Uses RepeatModeler to generate de novo repeats within new genomes. Intensive. Requires a FNA file. 

### fastqc_run.sh
  Small code snippet that runs the FASTQC algorithm, which quality controls raw genetic sequences. Intensive. Requires FASTA file. 

### fetch_gene_symbols.py
  Exchanges orthogroup IDs for gene symbols. Draws from online resources at biodbnet to ensure that the correct gene symbols are chosen. Intensive. Requires specialised files from Master's Capstone, but can be   adjusted to deal with different files. 

### final_identifier.sh
  Directly associated with my Master's Capstone project. This code snippet adjusts orthogroup identifiers to gene IDs and vice versa. 

### gffread_run.sh
  Runs the GFFRead algorithm on genetic files. Intensive. Requires both GFF files and FNA files for each individual. 

### orthofinder_job.sh
  Runs the Orthofinder algorithm to assign orthogroups to each gene in the tested species pool. Intensive. Small code snippet takes around 7 days to run on supercluster. Requires protein FASTA files. 

### remove_empty.sh
  Removes empty alleles from VCF. Adjusted from StackOverFlow. Requires VCF files. 

### vcf2fasta.py
  Converts VCF file to FASTA file. Adjusted from online tools (VCF2FASTA tool). Requires VCF file. 
