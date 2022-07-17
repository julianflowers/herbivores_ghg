## snowball sampling with R

highschool

library(myScrapers); library(semanticscholar);library(tidygraph); library(ggraph)
library(tidyverse)

## let's start with the references from the systematic map paper

test_ss <- semanticscholar::S2_search_papers("What evidence exists on the impacts of large herbivores on climate change? A systematic map protocol")

https://api.semanticscholar.org/graph/v1/paper/466446d58e6e5e97e447e88dd9d4b05d4d4b4229/citations

ss_ids <- pluck(test_ss$data, "paperId")

refs <- jsonlite::fromJSON("https://api.semanticscholar.org/graph/v1/paper/466446d58e6e5e97e447e88dd9d4b05d4d4b4229/references", simplifyDataFrame = TRUE)
get_S2_refs <- function(paperId){
  #paperId <- "466446d58e6e5e97e447e88dd9d4b05d4d4b4229"
  require(semanticscholar)
  require(jsonlite)
  require(data.table)
  api <- S2_api()
  url <- paste0(api, "graph/v1/paper/", paperId, "/references")
  refs <- fromJSON(url, simplifyDataFrame=TRUE)
  refs <- as.data.table(refs) 
}

refs <- get_S2_refs("466446d58e6e5e97e447e88dd9d4b05d4d4b4229")


get_S2_citations <- function(paperId){
  #paperId <- "466446d58e6e5e97e447e88dd9d4b05d4d4b4229"
  require(semanticscholar)
  require(jsonlite)
  api <- S2_api()
  url <- paste0(api, "graph/v1/paper/", paperId, "/citations")
  cit <- fromJSON(url, simplifyDataFrame=TRUE)
  cit <- as_tibble(cit) |>
  
}

refs$data$citedPaper$paperId

cit <- get_S2_citations(refs$data$citedPaper$paperId[2])

safe_refs <- possibly(get_S2_refs, otherwise = NA_real_)
safe_cits <- possibly(get_S2_citations, otherwise = NA_real_)


round1 <- refs |> 
  mutate(round1 = map(data.citedPaper.paperId, safe_refs))




round1 <- round1 |>
  mutate(ncol= map(round1, ncol)) |>
  drop_na() |>
  filter(ncol>2) |> 
  mutate(round1 = map(round1, ~select(.x, data.citedPaper.paperId, data.citedPaper.title))) |>
  unnest("round1", names_repair = "universal")

round1 <- round1 |>
  group_by(data.citedPaper.paperId...2) |>
  mutate(n = n())

round1 |>
  as_tbl_graph() |>
  ggraph(layout = 'fr') +
  geom_edge_link(aes(colour = n)) +
  geom_node_point() + 
  #geom_node_text(aes(label = name), size = 2) +
  theme(legend.position = 'bottom') +
  coord_fixed()
round2 <- round1 |>
  mutate(round2 = map(data.citedPaper.paperId...2, safe_cits))

## we'll do one round of sampling

round1 <- map(ss_ids[1], S2_paper) |>
  map(c("references", "paperId")) |>
  enframe() |>
  unnest("value") |>
  mutate(refs_2 = map(value, S2_paper) |> map(c("references", "paperId")))



round1 |>
  mutate(tldr = map(value, get_tldr))

## we'll identify duplicates in references and create a network map to explore the relationship
round1_1 <- round1 |>
  unnest("refs_2") |>
  #count(refs_2)
  janitor::get_dupes("refs_2") |>
  group_by(value) |>
  mutate(n = n()) |>
  select(value, refs_2, n) 

rou

round1_1 |>
  mutate(class = n_distinct(refs_2))


round_graph <- round1_1 |>
  tidygraph::as_tbl_graph() 
glimpse(round_graph)
  
round_graph |>
  ggraph(layout = 'fr') +
  geom_edge_link(aes(colour = factor(n))) +
  geom_node_point() + 
  #geom_node_text(aes(label = name), size = 2) +
  theme(legend.position = 'bottom') +
  coord_fixed()

# round2 <- round1 |>
#   unnest("refs_2") |>
#          mutate(refs_3 = map(refs_2, S2_paper) |> map(c("references", "paperId")))



