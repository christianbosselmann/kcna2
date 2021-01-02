# blomap script, ref. Maetschke, Stefan and Towsey, Michael W. and Boden, Mikael (2005) Blomap: an encoding of amino acids which improves signal peptide cleavage site prediction . In Chen, Yi-Ping Phoebe and Wong, Limsoon, Eds. Proceedings Third Asia Pacific Bioinformatics Conference 1, pages pp. 141-150, Singapore.
# This simple script expects an input called "input.xlsx" saved to wd
# with two columns (a1 = original amino acid, a2 = mutated amino acid)
# extremely hacky and dirty code

# load libraries
library(dplyr)
library(openxlsx)
library(tibble)
library(tidyverse)
library(data.table)

# get input
input <- read.xlsx(xlsxFile="input.xlsx",sheet=1,colNames=TRUE)
df <- input

# grab matrix function from github
blomap <- readr::read_tsv("https://gist.githubusercontent.com/christianbosselmann/8a5b1e41aa475db67d8555d69e92650c/raw/2fe6ca35748377c31307c821426fe2dfeaa3fe03/blomap62.tsv") 

# apply to first amino acid
df <- merge(df, blomap, by.x="aa1", by.y="aa")

# set names
setnames(df, old = c('dim1','dim2', 'dim3', 'dim4', 'dim5'), new = c('aa1_dim1','aa1_dim2', 'aa1_dim3', 'aa1_dim4', 'aa1_dim5'))

# apply to second amino acid
df <- merge(df, blomap, by.x="aa2", by.y="aa")

# set names
setnames(df, old = c('dim1','dim2', 'dim3', 'dim4', 'dim5'), new = c('aa2_dim1','aa2_dim2', 'aa2_dim3', 'aa2_dim4', 'aa2_dim5'))

tibble(df)
write.xlsx(df,"output.xlsx")
