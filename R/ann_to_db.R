setwd("~/Downloads")
library(tidyverse)

ann <- list.files(pattern = ".ann$", full.names = TRUE)


read_delim(ann[c(1, 3:5)])

taxa_db <- map_dfr(ann[c(1, 3:5)], ~(read_delim(.x, col_names = c("index", "locations", "taxa")) |> mutate(filename = basename((.x)))))

taxa_db |>
  select(-5) |>
  gt::gt()
