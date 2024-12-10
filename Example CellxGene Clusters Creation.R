library(Seurat)
library(tidyverse)

DimPlot(b1b2ss, reduction = "tsne")

tibble(index = colnames(b1b2ss), clusterID = Idents(b1b2ss)) %>%
  write_csv(file = sprintf("Cluster_mappings_%s.csv", Sys.Date()))

#cellxgene launch brain2_edited_genenames.h5ad --max-category-items 500 --annotations-file Cluster_mappings_2024-12-09.csv