library(readtext); library(pdftools);library(tidyverse)

p <- here::here("~/Downloads/herbivory-corpus")

f <- list.files(p, "pdf", full.names = T)

f

x <- map_dfr(f, readtext)

x <- mutate(x, lat_long = str_extract_all(text, "\\d{1,2}◦\\s*\\d{1,2}.*[NSEW]|\\d{1,2}:\\d{1,2}:\\d{1,2}.*[NSEW]|\\d{1,2}°\\s*\\d{1,2}.*[NSEW]|\\d{1,2}\\.\\d{1,2}°.*[NSEW]|\\d{1,2}\\.\\d{1,2}◦.*[NSEW]"))
                                        
x |>
  unnest("lat_long") |>
  select(doc_id, lat_long) |>
  DT::datatable()
str(x)

methods <- str_squish(x[2])

str_match_all(methods, "\\d{1,2}°})
              
              
              \\D*\\d{1,2}\\D*\\d{1,2}\\.\\d{1,2}\\D*[NSEW]")

elevation <- parse_number(str_match(methods, "elevation\\D*\\d{1,}"))
