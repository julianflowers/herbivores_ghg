p <- setwd("~/Dropbox/My Mac (Julians-MBP-2)/Downloads")    
f <- list.files(p, "txt", full.names = TRUE)
f
library(pacman)
p_load_gh("ropensci/fulltext")
library(roadoi)
library(pubchunks)
library(data.table)
p_load(tidyverse, readtext, pdftools)

txt <- read_delim(f[5])

doi <- txt |>
  filter(TY == "DO") |>
  pluck("JOUR")


doi[1]
t <- roadoi::oadoi_fetch(doi[1:100], email = "jrf128@student.aru.ac.uk")

safe_read <- possibly(readtext, otherwise = NA_real_)

mutate(text = map(url_for_pdf, ~safe_read(.x)))


## extract text
pdfs <- t |>
  filter(is_oa == "TRUE") |>
  select(doi, oa_status, oa_locations) |>
  unnest(oa_locations) |>
  select(doi, url, url_for_pdf) |>
  filter(str_detect(url_for_pdf, "\\.pdf$")) |>
   mutate(text = map(url_for_pdf, ~safe_read(.x)))

pdfs <- pdfs |>
 select(doi, text) |>
 unnest_wider("text") |>
 mutate(text = str_squish(text)) |>
  select(1:3)

## download pdfs
pdf_links <- t |>
  filter(is_oa == "TRUE") |>
  select(doi, oa_status, oa_locations) |>
  unnest(oa_locations) |>
  select(doi, url, url_for_pdf) |>
  drop_na() |>
  pluck("url_for_pdf") 


map(pdf_links, ~downloader::download(.x, basename(.x)))

  
pdfs$text[[1]]

t
