library(Seurat)

### Plot type/settings can be changed, default is the top 25 markers of the gene in a DotPlot with title = the cluster name

#creates plot with name or number of cluster 
geneset<- FindMarkers(SEURAT_OBJ, ident.1 = "CLUSTER NAME OR NUMBER")
markers.geneset <- tibble::rownames_to_column(geneset, "value")
colnames(markers.geneset) <- c("gene","p value" ,"avglog2FC", "pct.1", "pct.2", "p_val_adj")
stuff <- head(markers.geneset[1], n=25)
features <- unlist(stuff, use.names = F)
DotPlot(SEURAT_OBJ, features = features)

### will output all plots to console ###
for (i in levels(SEURAT_OBJ)) {
  geneset<- FindMarkers(SEURAT_OBJ, ident.1 = i)
  markers.geneset <- tibble::rownames_to_column(geneset, "value")
  colnames(markers.geneset) <- c("gene","p value" ,"avglog2FC", "pct.1", "pct.2", "p_val_adj")
  stuff <- head(markers.geneset[1], n=25)
  features <- unlist(stuff, use.names = F)
  print(DotPlot(SEURAT_OBJ, features = features) + ggtitle(i))
}


### will output all plots in working directory
for (i in levels(SEURAT_OBJ)) {
  geneset<- FindMarkers(SEURAT_OBJ, ident.1 = i)
  markers.geneset <- tibble::rownames_to_column(geneset, "value")
  colnames(markers.geneset) <- c("gene","p value" ,"avglog2FC", "pct.1", "pct.2", "p_val_adj")
  stuff <- head(markers.geneset[1], n=25)
  features <- unlist(stuff, use.names = F)
  DotPlot(SEURAT_OBJ, features = features) + ggtitle(i)
  ggsave(i, device = png, bg = 'white')
}

#### Outputs top 25 markers for each gene as columns in a dataframe df
###Run all of this, not just the for loop
rownumber = c(1:25)
#Adjust rownumber value for desired # of genes, for example rownumber = c(1:50) if n=50 in for loop 
df = data.frame(rownumber)

for (i in levels(SEURAT_OBJ)) {
  geneset<- FindMarkers(SEURAT_OBJ, ident.1 = i)
  markers.geneset <- tibble::rownames_to_column(geneset, "value")
  colnames(markers.geneset) <- c("gene","p value" ,"avglog2FC", "pct.1", "pct.2", "p_val_adj")
  stuff <- head(markers.geneset[1], n=25)
  df <-cbind(df, i = stuff)
}
df$rownumber <- NULL
colnames(df) =  levels(SEURAT_OBJ)
#creates excel document from df
#run install.packages("writexl") and then library(writexl)

write_xlsx(df, "PATH/NAME/SEURAT_OBJ.xslx")


#edit excel doc as needed, then
#run 
install.packages("readxl") 
#and then 
library(readxl)
dff <- read_excel("SEURAT_OBJ.xslx")
dff <- as.data.frame(dff)

#will make individual feature plots for each gene in the excel document
for (i in levels(SEURAT_OBJ)) {
  for (f in dff[i]) {
    feat <- dplyr::pull(dff, i)
    for (c in feat){
      if (is.na(c) == F){
        FeaturePlot(SEURAT_OBJ, features = c, pt.size = 1.25)
        fname <- paste(i , "-" , c,".jpeg")
        ggsave(filename = fname)
      }
      else {}
    } 
  }
}

#makes cellxgene-compatible CSV
library(tidyverse)
tibble(index = colnames(Chat_cluster), clusterID = Idents(Chat_cluster)) %>%
  write_csv(file = sprintf("Chat_cluster_cluster_mappings_%s.csv", Sys.Date()))

#then in cellxgene run 
#cellxgene launch XXXX.h5ad --max-category-items 500 --annotations-file cluster_mappings_XXXX-XX-XX.csv

