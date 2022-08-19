## extracting lat longs

library(pacman)
pacman::p_load(tidyverse, readxl, here, skimr, overviewR, ggmap, fulltext, tidytext)       ## readxl is needed to load excel files into R
library(semanticscholar)

## the `here` package helps with file paths


path <- here::here("data")

xls <- list.files(path, "xls", full.names = TRUE)

data <- readxl::read_xlsx(xls[2])

data <- data |>
  janitor::clean_names()

## titles
titles <- data$title

s1 <- map(titles, ~semanticscholar::S2_search_papers(.x))
ids <- map(s1, c("data", "paperId"))
ids <- map_chr(ids, 1)

details <- map(ids, semanticscholar::S2_paper)

dois <- map(details, "doi") |>
  unlist()

## which are open access

open_access <- map_chr(details, "is_open_access")

ft <- map(dois, ft_get)
ft_get(dois[18])

library(rwos)
library(wosr)
wosr::auth()
wosr::auth(username = "jrf128@student.aru.ac.uk", password = "Gull-bill3d-tern!")
rwos::wos_authenticate(username = "jrf128@student.aru.ac.uk", password = "Gull-bill3d-tern!")

path1 <- here::here("~/Downloads/herbivory-corpus")
corp_files <- list.files(path1, "pdf", full.names = TRUE)

test <- ft_table(path1)

head(test)

dim(test)

test$paths

pattern2 <- "\\d{1,2}\\D*\\d{1,2}\\D*\\d{1,2}\\D*[NSEW]"             ## e.g. 52 8' 12\"N
pattern3 <- "\\d{1,2}\\D*\\d{1,2}\\D*[NS]"                         ## e.g. 52Â°86' N
pattern2a <- "\\d{1,2}\\D*\\d{1,2}\\.\\d{1,2}\\.\\d{1,2}\\D*[NSEW]" 
pattern2b <- "\\d{1,2}\\D*\\d{1,2}\\.\\d{1,2}\\D*[NSEW]"## eg 52 25' 43.76"N
pattern4 <- "[EW]\\d{1,2}\\D*\\d{1,2}\\D*\\d{1,2}"
pattern5 <- "\\d{1,2}\\D*\\d{1,2}\\D*\\d{1,2}\\D*[EW]" 
pattern6 <- "\\d{1,2}\\D*\\d{1,2}\\D*[EW]"
pattern7 <- "[NS]\\d{1,2}[[:punct:]]\\d{1,2}[[:punct:]]\\d{1,2}"
pattern8 <- "[EW]\\d{1,2}[[:punct:]]\\d{1,2}[[:punct:]]\\d{1,2}"

test|>
  unnest_tokens("sents", text, token = "sentences") |>
  DT::datatable()
  
  mutate(lat = str_extract_all(text, pattern2a), 
         lat = ifelse(is.na(lat), str_extract_all(text, pattern2), lat), 
         lat = ifelse(is.na(lat), str_extract_all(text, pattern7), lat)) |>
  select(paths, lat) |>
  unnest("lat") |>
  View()


, 
         lat = ifelse(is.na(lat), str_extract(latitude_n_s, pattern2), lat), 
         lat = ifelse(is.na(lat), str_extract(latitude_n_s, pattern7), lat), 
         long = str_extract(longitude_e_w, pattern2),
         long = ifelse(is.na(long), str_extract(longitude_e_w, pattern2b), long),
         long = ifelse(is.na(long), str_extract(longitude_e_w, pattern8), long), 
         long = ifelse(is.na(long), str_extract(longitude_e_w, pattern6), long))
  str_match_all("[A-Z]{4,}")


View(test)

corp_files[1]

pdftools::pdf_text(corp_files[1]) |>
  str_squish()


library(furrr)
plan(multisession)
texts <- future_map(corp_files, pdftools::pdf_text)
texts <- map(texts, str_squish)

text_df <- map_dfr(texts, enframe)

text_df |>
  DT::datatable()
