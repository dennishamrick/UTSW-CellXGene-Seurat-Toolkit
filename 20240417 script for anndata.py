##Run this in python, edit names/location of file as needed for use before running
print('Importing packages')
import os
import sys
import pandas as pd
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

while True:
    annotations = input("Enter your .csv annotations path: ")
    if not os.path.exists(annotations):
        print("Annotations file not found.")
    else: 
        break
print("Reading .csv...")
new_annotations = pd.read_csv(annotations,
                         comment='#',
                         dtype='category',
                         index_col=0)
print(".csv read successfully. Joining...")
new1.obs = new1.obs.join(new_annotations)
while True:
    answer = input("New .h5ad created! Compressed files (gzip format) will take up much less space but will be slower to load. Would you like to compress the output file? Enter y or n: ")
    if answer.lower() == 'y':
        print('Writing compressed .h5ad...')
        new1.write_h5ad(basename + '_annotated.h5ad', compression = 'gzip')
        print('New h5ad written to ' + cwd)
        exit()
    elif answer.lower() == 'n':
        print('Writing .h5ad...')
        new1.write_h5ad(basename + '_annotated.h5ad')
        print('New h5ad written to ' + cwd)
        exit()
    else: 
        print("Invalid input. Please enter y or n.")


