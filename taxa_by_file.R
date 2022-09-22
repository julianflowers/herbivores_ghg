path <- here::here("/Users/julianflowers/Library/Mobile Documents/com~apple~CloudDocs/Desktop/herbivores_ghg/my_corpus")

f <- list.files(path, ".csv$", full.names = T)
f

library(quanteda);library(tidyverse)
texts <- purrr::map_dfr(f[-c(40, 41, 47, 62)], ~read_csv(.x) |> mutate(file = basename(.x))) 

texts |>
  select(file, Name) |>
  group_by(file) |>
  distinct()|>
  mutate(file = str_remove(file, "\\.csv")) |>
  write_csv("taxa_gnr.csv")


texts |>
  tidyr::unnest_wider("value") |>
  tidyr::unnest_auto("children") -> texts1

texts1 |>
  mutate(title1 = map(children, "title")) |>
  unnest(title1) |>
  View()

kwic(corp, "Title")

head(texts)

taxa |> 
  count(filename, x3, sort = T) |>
  filter(n > 4) |>
  mutate(f = str_sub(filename, 1, 5)) |>
  ggplot(aes(f, reorder(x3, n), fill = n)) +
  geom_tile() +
  theme(axis.text.y = element_text(size = 5), 
        axis.text.x = element_text(angle = 90, hjust = 1)) +
  viridis::scale_fill_viridis(option = "rocket") +
  scale_x_discrete(position = "top") +
  labs(y = "")

annotated_herbivory_ghg <- read_csv("data/annotated_herbivory_ghg.csv", col_select = c("file", "text", "entity"))

locs <- annotated_herbivory_ghg |>
  filter(entity == "GPE") |>
  distinct() |>
  group_by(file) |>
  summarise(locs = paste(text, collapse = ", ")) 

chems <- annotated_herbivory_ghg |>
  filter(entity == "Chemical") |>
  distinct() |>
  group_by(file) |>
  summarise(locs = paste(text, collapse = ", ")) 

taxa <- annotated_herbivory_ghg |>
  filter(entity == "Species") |>
  distinct() |>
  group_by(file) |>
  summarise(locs = paste(text, collapse = ", ")) 
 

loc_1 <- annotated_herbivory_ghg |>
  filter(entity == "LOC") |>
  distinct() |>
  group_by(file) |>
  summarise(locs = paste(text, collapse = ", ")) 

quant <- annotated_herbivory_ghg |>
  filter(entity == "QUANTITY") |>
  distinct() |>
  group_by(file) |>
  summarise(locs = paste(text, collapse = ", ")) 

annotated_ghg <- locs |> 
  left_join(loc_1, by = "file") |>
  left_join(taxa, by = "file") |>
  left_join(chems, by = "file") |>
  left_join(quant, by = "file") |>
  select(file, locs = locs.x, locs_1 = locs.y, taxa = locs.x.x, chemicals = locs.y.y, quantities = locs) 

annotated_ghg |>
  write_csv("annotated_ghg.csv")

annotated_ghg |>
  mutate(coords = str_match(quantities, 
                            "(\\d{1,2})\\D?(°|\\.|◦)\\D?(\\d{1,2})\\D*([NSEW])")) |>
  unnest_auto("coords") |>
  DT::datatable()

         