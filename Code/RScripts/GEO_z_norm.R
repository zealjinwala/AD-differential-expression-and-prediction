#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
require('GEOquery')
require('dplyr')
require('doParallel')
require('tidyverse')

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("Must supply outdir", call.=FALSE)
}
print(args[1])

geo_list = c('GSE63060', 'GSE63061', 'GSE44772') #GEO ACC numbers
col_list = c('Accession', 'Accession', 'GB_ACC') #names of columns we want
setwd(args[1])  #setwd to bmes.datadir

#This code block finds the intersect of genes across all files
gse = getGEO(geo_list[1]) #downloads data from GEO,
genes1 = gse[[paste0(geo_list[1], "_series_matrix.txt.gz")]]@featureData@data[[col_list[1]]]
gse = getGEO(geo_list[2])
genes2 = gse[[paste0(geo_list[2], "_series_matrix.txt.gz")]]@featureData@data[[col_list[2]]]
gse = getGEO(geo_list[3])
genes3 = gse[[paste0(geo_list[3], "_series_matrix.txt.gz")]]@featureData@data[[col_list[3]]]
genes1_f = str_extract(genes1, '[A-Za-z]*_[0-9]*') #only keeps gene names
genes2_f = str_extract(genes2, '[A-Za-z]*_[0-9]*')
genes3_f = str_extract(genes3, '[A-Za-z]*_[0-9]*')

tmp = intersect(genes1_f, genes2_f)
int = intersect(genes3_f, tmp)    #this is the intersection

write_z_norm = function(geo, column){
  gse = getGEO(geo)
  print(geo)
  print(column)
  emat = gse[[paste0(geo, "_series_matrix.txt.gz")]]@assayData[["exprs"]]
  genes = gse[[paste0(geo, "_series_matrix.txt.gz")]]@featureData@data[[column]]
  genes_f = str_extract(genes, '[A-Za-z]*_[0-9]*') #makes genes comparable to "int"

  emat = emat[genes_f %in% int,]
  genes = genes_f[genes_f %in% int]
  emat = aggregate(emat, list(genes), mean) #average same genes

  #z-norm every gene for each column
  NormedEmat = foreach(i = 2:ncol(emat), .combine = cbind) %do% {
    z_normed = (emat[,i] -mean(emat[, i], na.rm = T))/sd(emat[, i], na.rm = T)
  }
  colnames(NormedEmat) = colnames(emat)[-1]  #make colnames GEO_subjectID
  NormedEmat = as.data.frame(NormedEmat)

  NormedEmat = cbind(emat[,1], NormedEmat)
  colnames(NormedEmat)[1] = 'genes'
  NormedEmat = NormedEmat[order(NormedEmat$genes),]
  NormedEmat = t(NormedEmat)   #save as subjects by genes for SVM later...
  
  write.csv(NormedEmat, paste0(geo, "_z_intersectGenes.csv"))
  subjid_data = gse[[paste0(geo, "_series_matrix.txt.gz")]]@phenoData@data
  
  if (geo == "GSE44772")#reduce size of this specific metadata
    subjid_data = select(subjid_data, geo_accession, source_name_ch2,
                         characteristics_ch2, characteristics_ch2.1, characteristics_ch2.2)
  write.csv(subjid_data, paste0(geo, "_subject_data.csv"))

}

mapply(write_z_norm, geo_list, col_list)

