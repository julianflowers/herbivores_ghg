library(tidyverse)
library(myScrapers)
library(tidytext)
p <- setwd("~/Dropbox/My Mac (Julians-MBP-2)/Downloads")    
f <- list.files(p, "txt", full.names = TRUE)
txt <- read_delim(f[8])

abs <- txt |>
  filter(TY %in% c("DO", "AB", "T1")) |>
  select(TY, JOUR) |>
  group_by(TY) |>
  mutate(id = row_number()) |>
  pivot_wider(names_from = "TY", values_from = "JOUR") |>
  rename(title = T1, absText = AB, pmid = DO)

corpus <- create_abstract_corpus(abs)

clust <- create_abstract_cluster(corpus$corpus, perplexity = 20, minPts = 4)
clust$cluster_count

labels <- create_cluster_labels(corpus$corpus, clust$clustering)
labels$labels

clustered_abs <- labels$results |>
  left_join(abs, by = c("pmid.value" = "pmid"))

clustered_titles <- clustered_abs |>
  select(title, clus_names)

clustered_titles |>
  filter(str_detect(clus_names, "result")) |>
  select(title)

ggplot() +
  geom_point(data = labels$results, aes(X1, X2, colour = clus_names), show.legend = FALSE) +
  geom_point(data = labels$plot, aes(medX, medY, colour = factor(clus_names)), 
             shape = "X", size = rel(4), show.legend = FALSE) + 
  ggrepel::geom_label_repel(data = labels$plot, aes(medX, medY, label = clus_names), size = 2.5) 


             