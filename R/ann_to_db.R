p <- here::here("my_ann")
library(tidyverse)

ann <- list.files(p, pattern = ".ann$", full.names = TRUE)



ann_to_db <- function(file){
  
  require(readr)
  require(dplyr)
  taxa_db <- read_delim(file, col_names = c("x1", "x2", "x3"))
  taxa_db <- taxa_db |>
    mutate(filename = basename((file)))
}

x <- map(ann, ann_to_db) %>%
  .[-67]

x <- map_dfr(x, tibble)

x |>
  count(x3, sort = T)

x |>
  write_csv("data/taxa.csv")


