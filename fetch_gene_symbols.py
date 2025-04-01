import pandas as pd
import requests
import time

# Input and output file paths
input_file = "/gpfs/scratch/hridout/Proteins_Species_Genes.txt"
output_file = "/gpfs/scratch/hridout/Protein_Species_Gene_with_GeneSymbols.txt"
log_file = "/gpfs/scratch/hridout/error_log.txt"
progress_log = "/gpfs/scratch/hridout/progress_log.txt"

# Batch size and API endpoint
batch_size = 20
api_endpoint = "https://biodbnet.abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi"

# Function to fetch gene symbols from the API
def get_gene_symbols(protein_ids):
    # Remove version numbers from protein IDs
    stripped_ids = [protein.split(".")[0] for protein in protein_ids]
    
    query = {
	"method": "db2db",
        "input": "RefSeq Protein Accession",
        "inputValues": ",".join(stripped_ids),
        "outputs": "Gene Symbol",
        "format": "json"
    }
    response = requests.get(api_endpoint, params=query)
    if response.status_code != 200:
        raise Exception(f"API Error: {response.status_code}")
    data = response.json()

    # Parse response and match gene symbols to input protein IDs
    id_to_symbol = {}
    for entry in data.values():
        if isinstance(entry, dict) and "InputValue" in entry:
            input_id = entry["InputValue"]
            outputs = entry.get("outputs", {})
if "Gene Symbol" in outputs:
                id_to_symbol[input_id] = ", ".join(outputs["Gene Symbol"])
    return [id_to_symbol.get(protein.split(".")[0], "No symbol found") for protein in protein_ids]

# Load input data
data = pd.read_csv(input_file, sep="\t", names=["ProteinID", "Species"], dtype=str)

# Open files for writing output and logging progress
with open(output_file, "w") as outfile, open(log_file, "w") as error_log, open(progress_log, "a+") as progress:
    # Write header to the output file
    if progress.tell() == 0:  # Only write the header if progress log is empty
        outfile.write("ProteinID\tSpecies\tGeneSymbol\n")
        progress.write("0\n")  # Start at line 0

    # Read the last processed line number
    progress.seek(0)
    last_processed_line = int(progress.readlines()[-1].strip())

    # Start processing from the next line
    for i in range(last_processed_line, len(data), batch_size):
        # Get the current batch
        protein_ids_batch = data["ProteinID"].iloc[i:i + batch_size].tolist()
        species_batch = data["Species"].iloc[i:i + batch_size].tolist()

        print(f"Processing batch {i} to {i + batch_size - 1}...")

        # Get gene symbols with retry logic
        retries = 3
        for attempt in range(retries):
            try:
                symbols = get_gene_symbols(protein_ids_batch)
                break
            except Exception as e:
                print(f"Retry {attempt + 1}/{retries} for batch {i}: {e}")
                time.sleep(5)
        else:
            # Log failed batches after retries
            for protein_id in protein_ids_batch:
                error_log.write(f"Failed: {protein_id}\n")
            symbols = ["Error"] * len(protein_ids_batch)


        # Write results to the output file
        for protein_id, species, symbol in zip(protein_ids_batch, species_batch, symbols):
            outfile.write(f"{protein_id}\t{species}\t{symbol}\n")

        # Record progress
        progress.write(f"{i + batch_size}\n")
        progress.flush()

        # Pause to avoid rate limits
        time.sleep(1)

print("Processing complete. Check the output and logs for details.")



