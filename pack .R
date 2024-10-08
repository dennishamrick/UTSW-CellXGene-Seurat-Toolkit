

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("zellkonverter")
install.packages("reticulate")
devtools::install_github("cellgeni/schard")

brain2 = schard::h5ad2seurat('brain2_edited_genenames.h5ad')

library(Seurat)
library(dplyr)
library(ggplot2)
library(zellkonverter)
library(schard)
library(devtools)

library(nothing)

brain2_ad <- readH5AD("brain2_edited_genenames.h5ad")
brain2 <- AnnData2SCE(brain2_ad)
brain2_seurat <- as.Seurat(brain2, counts = "counts")


#converting h5ad to rds, takes forever
###############################################################
adata <- read_h5ad("brain1_edited_genenames.h5ad", to = "InMemoryAnnData")
brain1 <- adata$to_Seurat()


bdata <- read_h5ad("brain2_edited_genenames.h5ad", to = "InMemoryAnnData")
brain2 <- bdata$to_Seurat()
###############################################################

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
brain2_metadata <- brain1[[]]
colnames(brain2_metadata)

#subsetting object based on object
Idents(brain2) <- "CATEGORY"
table(brain2)
table(Idents(brain2))
b2SUBSET <- subset(brain2, idents = c("LABEL-1","LABEL-2","LABEL-N"))
b2SUBSET
#removes brain2 from environment
rm(brain2)

