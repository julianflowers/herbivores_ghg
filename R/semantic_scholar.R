## try semantic scholar

library(pacman)
p_load_gh("kth-library/semanticscholar", dependencies = TRUE)
library(semanticscholar)
S2_api()

p <- setwd("~/Dropbox/My Mac (Julians-MBP-2)/Downloads")    
f <- list.files(p, "txt", full.names = TRUE)
txt <- read_delim(f[8])

doi <- txt |>
  filter(TY == "DO") |>
  pluck("JOUR")

my_refs <- zotero_references(doi[1:100])
my_refs[[1]]$journalArticle
ss_ids <- map(my_refs, "S2_paper")

get_tldr <- function(ss_id){
  require(jsonlite)
  
  #ss_id = ss_ids[1]
  url <- "https://api.semanticscholar.org/graph/v1/paper/"
  uri <- paste0(url, ss_id, "?fields=tldr")
  
  ext <- fromJSON(uri, simplifyDataFrame=TRUE)
  
  out <- 
  
}

safe_tldr <- possibly(get_tldr, otherwise = NA_real_)
out <- map(ss_ids, safe_tldr)

map(out, c("tldr", "text"))

out$tldr$text

safe_S2 <- possibly(S2_paper, otherwise = NA_real_)

paper <- map(ss_ids, ~safe_S2(.x))

paper[1]
map(paper, "abstract") |>
  enframe() |>
  filter(value != "NULL")


## ss seqrch

ss_search <- semanticscholar::S2_search_papers("herbivory AND fires ", limit = 100)
ids2 <- ss_search$data |>
  pluck("paperId")

ids2

titles <- ss_search$data$title

herb_paper <- map_dfr(titles, ~safe_S2(.x))

str(herb_paper)[[1]]

enframe(herb_paper) |>
  unnest("value")

map(herb_paper, c("topics")) |>
  enframe() |>
  unnest("value")


