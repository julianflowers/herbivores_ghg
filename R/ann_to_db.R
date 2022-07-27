setwd("~/Downloads")
library(tidyverse)

ann <- list.files(pattern = ".ann$", full.names = TRUE)
ann
read_delim(ann[1], col_names = c("index", "locations", "taxa"))

ann_to_db <- function(file){
  
  require(readr)
  require(dplyr)
  taxa_db <- read_delim(file, col_names = c("index", "locations", "taxa", "p")) |> 
                        mutate(filename = basename((file)))
}

x <- ann_to_db(ann[7])

x

taxa_db |>
  gt::gt()
