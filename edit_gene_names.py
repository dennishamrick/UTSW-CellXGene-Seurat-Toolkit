### CellxGene stores gene names as ENSMBL ID's, which are useful for standardization but are not easy to read for humans.

## Use this script to change ENSEMBL ID's to standard gene names. Very useful if you plan to analyze in Seurat. Edit the name of the h5ad as needed.

##
import os
import sys
import pandas as pd
import numpy as np
import scanpy as sc
import anndata as ad

filename = input("Enter your .h5ad filename:")

if not os.path.exists(filename):
    sys.exit("File not found.")
print("Reading h5ad...")
update_names=sc.read_h5ad(filename)
print("h5ad read. Updating gene names...")
gene_name = update_names.var_vector('gene_name')
update_names.var_names = update_names.var["gene_name"].copy()
update_names.var.index.name = None 
update_names.obs.index.name = None 
printf("Done! Writing h5ad...")
update_names.write_h5ad(filename + "_updated_genenames.h5ad")
printf("h5ad written to " filename + "_updated_genenames.h5ad.")
