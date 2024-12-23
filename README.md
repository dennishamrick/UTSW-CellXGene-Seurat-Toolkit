# UTSW CellXGene Seurat Toolkit

This github repository is intended to be used as a pipeline to analyze spatial/single-cell datasets from the website CellXGene using the R framework Seurat. You can download a .zip file with all of the scripts and this README file by pressing the green < > Code button and selecting 'Download Zip' from the menu that appears.

# Step By Step - Preparation:

It is recommended to run this workflow on a computer with at least 16 GB of RAM. You may be able to use a computer with 8 GB of RAM but performance will be slower if it works at all. All of these programs should work on Windows, Linux, or Mac OS. The instructions have been written with Linux or Mac's terminal in mind, but they should be transferrable to Windows' command line.

## 1. Download needed programs.

[Anaconda Distribution](https://www.anaconda.com/download)
[R](https://cran.rstudio.com/)
[RStudio](https://posit.co/download/rstudio-desktop/)

You will also need a browser to use CellXGene's interface. Firefox, Google Chrome, Microsoft Edge, or Safari should all work. If you are running a lower-spec computer, Google Chrome is not recommended as it will hog memory.

After downloading all of these programs, download the needed packages.

## 2. Create Anaconda environment with python packages/
Open terminal. Create a conda environment to use CellXGene in:

`conda create --yes -n cellxgene python=3.12`

Activate the environment (do this every time you use cellxgene):

`conda activate cellxgene`

Install needed packages:

`pip install cellxgene scanpy anndata`

## 3. Download R packages.
Download devtools, Seurat, tidyverse, Rtools, ggplot2, BiocManager, and anndataR. To download all at once:

`install.packages("devtools")

install.packages("Seurat")

install.packages("tidyverse")

install.packages("Rtools")

install.packages("ggplot2")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

devtools::install_github("scverse/anndataR", dependencies = TRUE)`

## 4. Download the CellXGene file of interest.
[CellXGene](https://cellxgene.cziscience.com/)

You can also, if using the Zhang et al. mouse brain datasets, download my pre-processed versions of two coronal sections from [LINK TBD]().

It is strongly encouraged to create a folder to store each file of interest in. This is because CellXGene creates annotation csv files, and it will help to stay organized if each file has a folder to catch these .csv files.

### 4b. Convert feature IDs from ENSMBL IDs to gene symbols.
By default, CellXGene datasets use ENSEMBL IDs for feature IDs. These are useful but non-human readable. They can be converted to gene symbols with the script `edit_gene_names.py`.

Activate your conda environment:

`conda activate cellxgene`

Change directory to whereever you have the script downloaded:

`cd Downloads/UTSW-CellXGene-Seurat-Toolkit`

Run the script

`python3 edit_gene_names.py`

The script will ask for an h5ad file, input the exact path of the h5ad file with its name.

`Enter your .h5ad path: /Documents/myfile.h5ad`

It will edit the gene names and output a file:

`myfile_updated_genenames.h5ad`.

# Step By Step - Analysis

## 1. Open your file in cellxgene and subset your group of interest.
Change directory to whereever you have your h5ad file stored.

`cd Downloads/MyCellXGeneDatasetFolder`

Activate your conda environment:

`conda activate cellxgene`

Launch your file:

`cellxgene launch myfile.h5ad`

CellXGene will print a link similar to `http://localhost:5005/`. Open it in your browser. If you encounter issues using it in Google Chrome, try Firefox on Windows/Linux or Safari on Mac.

If you have performance issues, you can use

`cellxgene launch myfile.h5ad --max-category-items 500`

You can subset based on gene expression, anatomical location, annotated cell types, or some combination of variables.
[CellXGene's documentation](https://cellxgene.cziscience.com/docs/01__CellxGene) is very useful and will be helpful in this step.
## 2. Merge your annotations into the h5ad file.
CellXGene will create an annotation file in .csv format with the categories you've created. You need to merge this annotation into the .h5ad file to port it into R. This can be done with `merge_annotations.py`. 

Activate your conda environment:

`conda activate cellxgene`

Change directory to whereever you have the script downloaded:

`cd Downloads/UTSW-CellXGene-Seurat-Toolkit`

Run the script

`python3 merge_annotations.py`

The script will ask for the path to an h5ad file and ask for the path to its .csv annotation file. It will merge them together, and then ask if you want a compressed or non-compressed output .h5ad file. Compressed files (gzip format) will take up much less space but will be slower to load. The output file will be created as 

`myfile_annotated.h5ad`.

## 3. Using generic_cellxgene.R
Open generic_cellxgene.R. It contains needed functions and instructions to import your .h5ad file, convert it into a Seurat object, and subset it based on your selections.

## 4. Perform analysis with Seurat.
Your object is now a standard seurat object and can be analyzed using that package. An example tutorial:
https://satijalab.org/seurat/articles/pbmc3k_tutorial.html

## 5. Output your cluster IDs as a .csv.
The needed function is at the bottom of generic_cellxgene.R:

`tibble(index = colnames(SEURAT_OBJ), clusterID = Idents(SEURAT_OBJ)) %>%
  write_csv(file = sprintf("cluster_mappings_%s.csv", Sys.Date()))`

The file will be outputted to your working directory with today's date as 
`cluster_mappings_XXXX-XX-XX.csv`.

## 6. Visualize your clusters in CellXGene.
Move your cluster_mappings.csv file into the same directory as the h5ad file they came from. Activate your cellxgene conda environment. Run the following command:

`cellxgene launch YOUR_CELLXGENE_FILE.h5ad --max-category-items 500 --annotations-file cluster_mappings_XXXX-XX-XX.csv`


