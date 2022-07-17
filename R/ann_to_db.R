setwd("~/Downloads")
library(tidyverse)

ann <- list.files(pattern = ".ann$", full.names = TRUE)


read_delim(ann[c(3, 6, 14)])

taxa_db <- map(ann, ~(read_delim(.x, col_names = c("index", "locations", "taxa")) |> 
                        mutate(filename = basename((.x)))))

taxa_db |>
  gt::gt()
