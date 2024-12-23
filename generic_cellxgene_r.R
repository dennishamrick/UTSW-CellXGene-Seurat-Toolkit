###This R script is intended for converting CellxGene h5ad files to the Seurat format, then converting them back to h5ad format for spatial analysis.
### It is modelled after the use case of analyzing the Zhang et al MERFISH mouse brain datasets, but should work for any CellxGene datasets. Edit variable names, number of read_h5ad() uses, etc as needed.

#installing needed packages
install.packages("Seurat")
install.packages("tidyverse")
install.packages("Rtools")
install.packages("ggplot2")
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
devtools::install_github("scverse/anndataR", dependencies = TRUE)
install.packages("devtools")

#load packages
library(Seurat)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(anndataR)

#replace h5ad_path with path to your cellxgene h5ad of interest 
adata <- read_h5ad(h5ad_path)
bdata <- read_h5ad(h5ad_path)

#converting anndata h5ad to seurat object. takes a long time especially for large objects.

###this script will assume you are using the Zhuang et al MERFISH dataset.
###variable names "brain1", "brain2" etc can be edited if you are not using this dataset or just want to use a different name

#starts a timer
start.time <- Sys.time()
#converts h5ad to seurat
brain1 <- adata$to_Seurat()
#ends timer and displays length of process
end.time <- Sys.time()
time.taken <- end.time - start.time
print("Done with to_seurat()")
time.taken
#deletes anndata object to save memory
rm(adata)

#same as above, just for another object.
# If your computer has less than 16-32 gigabytes of RAM or is an older model, you 
# may want to run each object separately to avoid crashing R or performing very slow.
start.time <- Sys.time()
brain2 <- bdata$to_Seurat()
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
rm(bdata)

###############################################################
### At this point you will have your seurat objects brain1 and brain2.


#calls the metadata of the object
brain1_metadata <- brain1[[]]

colnames(brain1_metadata)

#subsetting object based on object
Idents(brain1) <- "CATEGORY"
table(brain1)
table(Idents(brain1))
b1SUBSET <- subset(brain1, idents = c("LABEL-1","LABEL-2","LABEL-N"))
b1SUBSET
#removes brain1 from environment
rm(brain1)

#calls the metadata of the object
brain2_metadata <- brain2[[]]
colnames(brain2_metadata)

#subsetting object based on object
Idents(brain2) <- "CATEGORY"
table(brain2)
table(Idents(brain2))
b2SUBSET <- subset(brain2, idents = c("LABEL-1","LABEL-2","LABEL-N"))
b2SUBSET
#removes brain2 from environment
rm(brain2)

#perform analysis, cluster seurat object with created objects, merge if you want

#begin below section with clustered seurat object

#makes cellxgene-compatible CSV
tibble(index = colnames(SEURAT_OBJ), clusterID = Idents(SEURAT_OBJ)) %>%
  write_csv(file = sprintf("cluster_mappings_%s.csv", Sys.Date()))

#then in cellxgene run 
#cellxgene launch YOUR_CELLXGENE_FILE.h5ad --max-category-items 500 --annotations-file cluster_mappings_XXXX-XX-XX.csv

