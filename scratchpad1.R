#begin with clustered seurat object

library(tidyverse)
tibble(cellID = colnames(SEURAT_OBJ), clusterID = Idents(SEURAT_OBJ)) %>%
  write_csv(file = sprintf("cluster_mappings_%s.csv", Sys.Date()))

#change csv file name to whatever your file name/date is
clusterids_csv<-read.csv("cluster_mappings_2024-10-03.csv"
                         ,header=F)

heat <- function(filepath) { 
     read.table(file=filepath, dec=",", header=TRUE, sep="\t")
   }
heat("/home/.../file.txt")
heat()


add_cluster_ids <- function(cxg_annotation_csv, cids_csv){
  
}

#change path/filename as needed
brain1_csv<-read.csv("~/Documents/Dennis/20241002-cellxgene-trials/real/brain1_coronal-cell-labels-R7J3MXWU.csv"
                     , header = F)
#cleans up files and makes them compatible
brain1_csv<-brain1_csv[c(-1,-2,-3),]
colnames(brain1_csv) <-  c("index", "clusterID")
rownames(brain1_csv) <- NULL
colnames(clusterids_csv) <-  c("index", "clusterID")
clusterids_csv<-clusterids_csv[c(-1),]
rownames(clusterids_csv) <- NULL
clusterids_csv$clusterID<-as.character(clusterids_csv$clusterID)

#merges the files together
merged_csv<- left_join(brain1_csv,clusterids_csv, by = "index")

#remove unnecessary additional row and removes any cellIDs without matches
merged_csv$clusterID.x <- NULL
needed<-which(rownames(merged_csv) %in% rownames(brain1_csv))   
merged_csv<-merged_csv[needed,]
#changes column names to cellxgene compatible format, turns NAs in clusterID to "unassigned"
colnames(merged_csv) <- c("index", "clusterID")
merged_csv[is.na(merged_csv)] <- "unassigned"

#####quality checks######

#check that cluster names are preserved in the file
unique(merged_csv$clusterID)
#should look like
# [1] "unassigned"                                     "Mog Doc5 Sec14l5 (probable oligodendrocytes) 4" "Drd2 Htr1a Il1rapl2 3"                          "Slc24a4 Actn2 Ptk2b 1"                         
# [5] "Ecel1 Drd2 Sv2c 2"                              "Ndnf Bves Nxph3 0"                              "C1ql1 Spon1 Sox6 7"                             "Ntsr1 Gpx3 Syt17 5"                            
# [9] "Slc7a10 Fzd2 Gja2 6"                            "Cldn5 Fili1 Lef1 8"    

#checks that clusterIDs present
lm= length(unique(merged_csv$clusterID))
lb = length(unique(brain1_csv$clusterID))  

if (lm == lb){
  cat("Error, no clusterIDs detected in merged_csv")
} else{
  table(merged_csv$clusterID)
}


#checks that number of matching rows is correct
if(nrow(clusterids_csv) == nrow(merged_csv)) {
  cat("Number of rows correct")
} else{ 
  cat("Error, brain1_csv has",nrow(brain1_csv), 
               "rows while merged_csv has", nrow(merged_csv),"rows. 
Check to make sure that you have removed non-matching rows.")
} 


write.csv(merged_csv, file = "chat_merged.csv",row.names = F, quote = F)