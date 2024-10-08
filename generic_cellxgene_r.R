install.packages("Seurat")
install.packages("anndata")
install.packages("Rtools")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

devtools::install_github("scverse/anndataR", dependencies = TRUE)

install.packages("devtools")

library(Seurat)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(anndata)
library(anndataR, include.only = "to_seurat")

help(package = "anndataR")
install.packages("Seurat", dependencies=TRUE, INSTALL_opts = c('--no-lock'))
devtools::install_github("scverse/anndataR")

ad <- AnnData(
  X = matrix(1:6, nrow= 2),
  obs = data.frame(group = c("a","b"),row.names = c("s1","s2")),
  var = data.frame(type = c(1L,2L,3L), row.names = c("var1","var2","var3")),
  layers = list(
    spliced = matrix(4:9, nrow=2),
    unspliced = matrix(8:13, nrow = 2)
  )
)

view <- ad[-1,]
ad$X
view$X


view2<-adata[adata$obs$BICCN_subclass_label=="Astrocytes"]
view2$obs
rownames(view2$var) <- view2$var$feature_name

col <- colnames(adata$obs)
col["cell_type", drop = F]
view3 <- adata[as.vector(adata$obs=="cell_type")]
view3 <- adata[adata$X$obs["cell_type"]]

view3

view4 <- adata$obs["fov_x"]

select(adata, )


invert(adata$obs$fov_y) <- NULL
bdata <- adataadta

bdata <- adata[adata$obs[c('fov_y', 'volume')]]

bdata <- adata %>% select(obs == "fov_y")

adata[[colnames(adata$obs) == c("cell_type","organism")]]

view3 <- adata[adata$obs[, c("organism"), drop = FALSE]]
view3$X

BICCN_subclass_label

colnames(adata$obs)

#converting h5ad to rds, takes forever
###############################################################
start.time <- Sys.time()
adata <- read_h5ad("mouse_motor_cortex.h5ad")
end.time <- Sys.time()
time.taken <- end.time - start.time
print("Done with read_h5ad")
time.taken


xyz<-view2$X
xyz$obs["cell_type"]
abc<-adata$layers["counts"]

adata_small <- adata[adata$obs_keys()]

to_seurat() <- anndataR::to_seurat()

adata$to_Seurat()
start.time <- Sys.time()
brain1 <- adata$to_Seurat()
end.time <- Sys.time()
time.taken <- end.time - start.time
print("Done with to_seurat()")
time.taken

start.time <- Sys.time()
bdata <- read_h5ad("brain2_edited_genenames.h5ad", to = "InMemoryAnnData")
brain2 <- bdata$to_Seurat()
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken

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

