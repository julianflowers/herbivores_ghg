## snowball sampling with R

library(myScrapers); library(semanticscholar);library(tidygraph); library(ggraph); library(roadoi)
library(tidyverse);library(fulltext)

## let's start with the references from the systematic map paper
search <- "Regenerative rotational grazing management of dairy sheep increases springtime grass production and topsoil carbon storage"
test_ss <- semanticscholar::S2_search_papers(search)

details <- semanticscholar::S2_paper(test_ss$data$paperId)

details$doi

roadoi_addin()

ft <- roadoi::oadoi_fetch("10.1016/J.ECOLIND.2021.107484")
ft$best_oa_location[[1]]$url_for_landing_page

fulltext::ft_get(details$doi, type = "xml" ,verbose = TRUE) 

|>
  ft_collect()
ft$best_oa_location[[1]] |>
  glimpse()

glimpse(ft)

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

"466446d58e6e5e97e447e88dd9d4b05d4d4b4229"

refs <- get_S2_refs("466446d58e6e5e97e447e88dd9d4b05d4d4b4229")


get_S2_citations <- function(paperId){
  #paperId <- "466446d58e6e5e97e447e88dd9d4b05d4d4b4229"
  require(semanticscholar)
  require(jsonlite)
  require(data.table)
  api <- S2_api()
  url <- paste0(api, "graph/v1/paper/", paperId, "/citations")
  cit <- fromJSON(url, simplifyDataFrame=TRUE)
  cit <- as.data.table(cit) 
  
}


refs$data$citedPaper$paperId

cit <- get_S2_citations("672c52c4e0280b601b936df6b2f8ab1828312274")

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

round1 |>
  count(data.citedPaper.title...5, sort = TRUE)

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

library(tictoc)

tic()
round1 |>
  count(data.citedPaper.paperId...4, data.citedPaper.title...5, sort = TRUE) |>
  slice(1:300) |>
  drop_na() |>
  mutate(cits = map(data.citedPaper.paperId...4, safe_cits)) |>
  unnest("cits") -> test_cits
toc()

test_cits <- as.data.table(test_cits)

test_cits |>
  as_tbl_graph() |>
  ggraph(layout = 'nicely') +
  geom_edge_link(aes(colour = n)) +
  geom_node_point() + 
  #geom_node_text(aes(label = name), size = 2) +
  theme(legend.position = 'bottom') +
  coord_fixed()
  

round2 <- round1 |>
  mutate(cit_round = map(data.citedPaper.paperId...4, safe_cits))


sc <- safe_cits("4aadd075b0bd5b96dcff1e80ef5505f135cf44e2")
sc





  mutate(round2 = map(data.citedPaper.paperId...4[4], safe_cits))

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



