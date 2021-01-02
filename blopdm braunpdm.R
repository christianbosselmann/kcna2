# blomap62 ref Maetschke, Stefan, Towsey, Michael, & Boden, M (2005) BLOMAP: An Encoding Of Amino Acids Which Improves Signal Peptide Cleavage Site Prediction. In Chen, Y & Wong, L (Eds.) Proceedings of the 3rd Asia-Pacific Bioinformatics Conference (Advances in Bioinformatics and Computational Biology). Imperial College Press, Singapore, pp. 141-150.
# braunpdm ref Venkatarajan, M., Braun, W. New quantitative descriptors of amino acids based on multidimensional scaling of a large number of physical–chemical properties. J Mol Model 7, 445–453 (2001). https://doi.org/10.1007/s00894-001-0058-5

# This simple script calculates property distances matrices from the above refs
# expected input is "input.xlsx" saved to wd
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

# grab matrix function from github: blomap62
blomap <- readr::read_tsv("https://gist.githubusercontent.com/christianbosselmann/8a5b1e41aa475db67d8555d69e92650c/raw/2fe6ca35748377c31307c821426fe2dfeaa3fe03/blomap62.tsv") 

# apply to first amino acid
df <- merge(df, blomap, by.x="aa1", by.y="aa")

# set names
setnames(df, old = c('dim1','dim2', 'dim3', 'dim4', 'dim5'), new = c('aa1_dim1','aa1_dim2', 'aa1_dim3', 'aa1_dim4', 'aa1_dim5'))

# apply to second amino acid
df <- merge(df, blomap, by.x="aa2", by.y="aa")

# set names
setnames(df, old = c('dim1','dim2', 'dim3', 'dim4', 'dim5'), new = c('aa2_dim1','aa2_dim2', 'aa2_dim3', 'aa2_dim4', 'aa2_dim5'))

# grab matrix function from github: braunpdm
map <- readr::read_tsv("https://gist.githubusercontent.com/christianbosselmann/5e6053c4ea49f42099cedbf41bfc5d0d/raw/2d6284107fba92090de1b46369fe214c04613b02/braunpdm.tsv") 

# apply to first amino acid
df <- merge(df, map, by.x="aa1", by.y="aa")

# set names
setnames(df, old = c('E1','E2', 'E3', 'E4', 'E5'), new = c('aa1_E1','aa1_E2', 'aa1_E3', 'aa1_E4', 'aa1_E5'))

# apply to second amino acid
df <- merge(df, map, by.x="aa2", by.y="aa")

# set names
setnames(df, old = c('E1','E2', 'E3', 'E4', 'E5'), new = c('aa2_E1','aa2_E2', 'aa2_E3', 'aa2_E4', 'aa2_E5'))

# initialize columns
df$braunpdm <- NA
df$blopdm <- NA

# now to calculate euclidean distances dij
df$braunpdm <- sqrt(exp(df$aa2_E5 - df$aa1_E5) + exp(df$aa2_E4 - df$aa1_E4) + exp(df$aa2_E3 - df$aa1_E3) + exp(df$aa2_E2 - df$aa1_E2) + exp(df$aa2_E1 - df$aa1_E1))
df$blopdm <- sqrt(exp(df$aa2_dim5 - df$aa1_dim5) + exp(df$aa2_dim4 - df$aa1_dim4) + exp(df$aa2_dim3 - df$aa1_dim3) + exp(df$aa2_dim2 - df$aa1_dim2) + exp(df$aa2_dim1 - df$aa1_dim1))

# output
write.xlsx(df,"output.xlsx")
