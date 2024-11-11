### CellxGene stores gene names as ENSMBL ID's, which are useful for standardization but are not easy to read for humans.

## Use this script to change ENSEMBL ID's to standard gene names. Very useful if you plan to analyze in Seurat. Edit the name of the h5ad as needed.

##

import pandas as pd
import numpy as np
import scanpy as sc
import anndata as ad

update_names=sc.read_h5ad("YOUR_CELLXGENE_FILE.h5ad")
gene_name = update_names.var_vector('gene_name')
update_names.var_names = update_names.var["gene_name"].copy()
update_names.var.index.name = None 
update_names.obs.index.name = None 
update_names.write_h5ad("YOUR_CELLXGENE_FILE_updated_genenames.h5ad")
