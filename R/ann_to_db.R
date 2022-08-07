p <- here::here("~/Downloads")
library(tidyverse)

ann <- list.files(p, pattern = ".ann$", full.names = TRUE)
ann
read_delim(ann[2], col_names = c("index", "locations", "taxa", "X4"))

ann_to_db <- function(file){
  
  require(readr)
  require(dplyr)
  taxa_db <- read_delim(ann[1], col_names = c("index", "locations", "taxa", "X4")) |> 
                        mutate(filename = basename((file)))
}

x <- map_dfr(ann, ann_to_db)

x

taxa_db |>
  gt::gt()
