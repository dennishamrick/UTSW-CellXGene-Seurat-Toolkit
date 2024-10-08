import pandas as pd
import scanpy as sc

new_annotations = pd.read_csv('brain1_coronal-cell-labels-R7J3MXWU.csv',
                         comment='#',
                         dtype='category',
                         index_col=0)
new1 = sc.read('brain1-coronal.h5ad')
new1.obs = new1.obs.join(new_annotations)

new1.write('brain1-coronal-annotated.h5ad')


new_annotations = pd.read_csv('abcd-cell-labels-X3IQP5VJ.csv',
                         comment='#',
                         dtype='category',
                         index_col=0)
new2 = sc.read('animal2-coronal.h5ad')
new2.obs = new2.obs.join(new_annotations)


new2.write('animal2-coronal-annotated.h5ad')


