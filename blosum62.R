# This simple script expects an input called "blosum62_input.xlsx" saved to dir, with two columns (a1 = original amino acid, a2 = mutated amino acid). Output is written as xslx to dir.

# load libraries
library(dplyr)
library(openxlsx)
library(tibble)
library(tidyverse)

# get input
blosum62_input <- read.xlsx(xlsxFile="blosum62_input.xlsx",sheet=1,colNames=TRUE)

# grab matrix function from github
blosum62 <- readr::read_tsv("https://gist.github.com/christianbosselmann/6bf4d9c61faf7fd41d7363fd396ffc0a/raw/0a2fc7f25c83e96e253717518666ef707fa23802/blosum62.tsv") %>% tidyr:: gather(SECOND,SCORE, -FIRST)
calculate_blosum62 <- function(a1, a2) {
  (blosum62 %>% dplyr::filter(FIRST == a1, SECOND == a2))$SCORE
  }

# apply to input
purrr::map2(blosum62_input$a1,blosum62_input$a2,calculate_blosum62) %>% tibble() -> blosum62_output

# preserve input, reorder for clarity
names(blosum62_output)[1] <- "blosum62_score"
cbind(blosum62_output, blosum62_input) -> blosum62_output
blosum62_output %>% relocate(blosum62_score,.after=last_col()) -> blosum62_output

# output
write.xlsx(blosum62_output,file="blosum62_output.xlsx")
