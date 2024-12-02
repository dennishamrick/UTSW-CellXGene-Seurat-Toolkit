### CellxGene stores gene names as ENSMBL ID's, which are useful for standardization but are not easy to read for humans.

## Use this script to change ENSEMBL ID's to standard gene names. Very useful if you plan to analyze in Seurat. Edit the name of the h5ad as needed.

##
print("Importing packages...")
import os
import sys
import pandas as pd
import numpy as np
import scanpy as sc
import anndata as ad
from pathlib import Path
print('Packages imported successfully.')
cwd = os.getcwd()
print('Current working directory is ' + cwd + '. Output file will be written here.') 

while True:
    filename = input("Enter your .h5ad path: ")
    if not os.path.exists(filename):
        print("h5ad file not found.")
    else:
        break

basename = Path(filename).stem
print("Reading .h5ad... ")
new1 = sc.read(filename)
print(".h5ad read successfully.")
print("Updating gene names...")
gene_name = update_names.var_vector('gene_name')
update_names.var_names = update_names.var["gene_name"].copy()
update_names.var.index.name = None 
update_names.obs.index.name = None 
print("Done! Writing h5ad...")
update_names.write_h5ad(basename + "_updated_genenames.h5ad")
print("h5ad written to " + basename + "_updated_genenames.h5ad.")
