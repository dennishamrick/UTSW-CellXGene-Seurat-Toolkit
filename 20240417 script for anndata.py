##Run this in python, edit names/location of file as needed for use before running

import pandas as pd
import scanpy as sc

new_annotations = pd.read_csv('YOUR_ANNOTATIONS_FILE.csv',
                         comment='#',
                         dtype='category',
                         index_col=0)
new1 = sc.read('NAME_OF_ORIGINAL_CELLXGENE_FILE.h5ad')
new1.obs = new1.obs.join(new_annotations)

new1.write('NAME_OF_ORIGINAL_CELLXGENE_FILE_annotated.h5ad')


