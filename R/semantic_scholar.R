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

safe_S2 <- possibly(S2_paper, otherwise = NA_real_)

paper <- map(ss_ids, ~safe_S2(.x))

paper[1]
map(paper, "abstract") |>
  enframe() |>
  filter(value != "NULL")


## ss seqrch

ss_search <- semanticscholar::S2_search_papers("herbivory climate change", limit = 100)
ids2 <- ss_search$data |>
  pluck("paperId")

herb_paper <- map(ids2, ~safe_S2(.x))

map(herb_paper, c("topics"))


