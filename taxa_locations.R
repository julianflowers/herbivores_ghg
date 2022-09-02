library(here); library(tidyverse)

p <- here("data")
f <- list.files(p, ".csv", full.names = TRUE)
f

ann <- read_csv(f[1]) |>
  select(file, text, entity, p)

locs <- ann |>
  group_by(file) |>
  filter(entity %in% c("LOC", "GPE")) |>
  distinct() |>
  summarise(locs = paste(text, collapse = ", "))

locs

species <- ann |>
  group_by(file) |>
  filter(entity %in% c("Species")) |>
  distinct() |>
  summarise(species = paste(text, collapse = ", "))

chem <- ann |>
  group_by(file) |>
  filter(entity %in% c("Chemical")) |>
  distinct() |>
  summarise(chem = paste(text, collapse = ", "))

dates <- ann |>
  group_by(file) |>
  filter(entity %in% c("DATE")) |>
  distinct() |>
  summarise(date = paste(text, collapse = ", "))

dates

locs |>
  left_join(species, by = "file") |>
  left_join(chem, by = "file") |>
  reactable::reactable()

taxa <- read_csv(f[3])

taxa |>
  #group_by(filename) |>
  count(taxa) 



|>
  ggplot(aes(filename, fct_rev(taxa))) +
  geom_tile(aes(fill = n))
