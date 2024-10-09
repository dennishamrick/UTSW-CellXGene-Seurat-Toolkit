import pandas as pd
import numpy as np
import scanpy as sc
import anndata as ad

b2=sc.read_h5ad("b2.h5ad")
gene_name = b2.var_vector('gene_name')
b2.var_names = b2.var["gene_name"].copy()
b2.var.index.name = None 
b2.obs.index.name = None 
b2.write_h5ad("brain2_edited_genenames.h5ad")
