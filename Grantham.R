# This simple script expects an input called "grantham_input.xlsx" saved to dir, with two columns (a1 = original amino acid, a2 = mutated amino acid). Output is written as xslx to dir.

# load libraries
library(dplyr)
library(openxlsx)
library(tibble)
library(tidyverse)

# get input
grantham_input <- read.xlsx(xlsxFile="grantham_input.xlsx",sheet=1,colNames=TRUE)

# grab matrix function from github
grantham <- readr::read_tsv("https://gist.github.com/christianbosselmann/da4048200608cd52250abb5fca89f7c7/raw/06ca51d40c80a4d9a7dd9a083a6ff33d643d7550/grantham.tsv") %>% tidyr:: gather(SECOND,SCORE, -FIRST) %>% dplyr::filter(SCORE > 0)
calculate_grantham <- function(a1, a2) {
  (grantham %>% dplyr::filter(FIRST == a1, SECOND == a2))$SCORE
  }

# apply to input
purrr::map2(grantham_input$a1,grantham_input$a2,calculate_grantham) %>% tibble() -> grantham_output

# preserve input, reorder for clarity
names(grantham_output)[1] <- "grantham_score"
cbind(grantham_output, grantham_input) -> grantham_output
grantham_output %>% relocate(grantham_score,.after=last_col()) -> grantham_output

# classify
# cite: Grantham R "Amino acid difference formula to help explain protein evolution", Science. 1974 Sep 6;185(4154):862-4.
grantham_output$grantham_class = cut(as.numeric(grantham_output$grantham_score),c(0,50,100,150,250))
levels(grantham_output$grantham_class) = c("conservative","moderately conservative","moderately radical","radical")

# output
write.xlsx(grantham_output,file="grantham_output.xlsx")