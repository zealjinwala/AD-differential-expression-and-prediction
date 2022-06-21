library(ggfortify)
library(tidyverse)
setwd('~/Dropbox/543FinalProject/NormedData/')
expr = read.csv('./GSE63060_z_intersectGenes.csv')
df = as.data.frame(sapply(expr[-1, -1], as.numeric))
colnames(df) = expr[1,-1]
rownames(df) = expr[-1,1]
pheno = read.csv('./GSE63060_subject_data.csv')

pca_res = prcomp(df, scale. = T)
df$disease = pheno$characteristics_ch1
df$disease = str_replace(df$disease, 'status: MCI', 'status: AD')

df = as_tibble(df)
autoplot(pca_res, data = df, colour = 'disease')

#####for other train datset######

expr = read.csv('./GSE63061_z_intersectGenes.csv')
df = as.data.frame(sapply(expr[-1, -1], as.numeric))

pheno = read.csv('./GSE63061_subject_data.csv')
colnames(df) = expr[1,-1]
rownames(df) = expr[-1,1]

df$disease = pheno$status.ch1
df = filter(df, disease != "borderline MCI" & disease != "OTHER" & disease != "CTL to AD" & disease != "MCI to CTL")
df$disease = str_replace(df$disease, 'MCI', 'AD')

df = as_tibble(df)
pca_res = prcomp(select(df, -disease), scale. = T)
autoplot(pca_res, data = df, colour = 'disease')
