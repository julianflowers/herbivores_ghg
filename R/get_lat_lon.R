## function to extract lat longs 

library(readtext); library(tidyverse)
here::here("~/Dropbox/My Mac (Julians-MBP-2)/Downloads")

f <- list.files(pattern =".pdf$", full.names = TRUE)

f
l <- "58ⴗ52.3′N, 93ⴗ41.0′W"

str_extract_all(l, "\\d{1,}.+(N|S|E|W)")


extract_lat_lon <-  function(text){
    regex_for_lat_lon <- "\\d{5,}.*\\d{5,}.?E|\\d{1,}.\\d{1,}.?'.[[:ALPHA:]]|\\d{1,}+(N|S)+\\d{1,}+(E|W)|\\d{1,}[[:blank:]].+(N|S|E|W)"

    t <- pdftools::pdf_text(text) 
    s <- t[2] |>
        str_extract_all(regex_for_lat_lon)
    s
} 

readtext(f[128])$text
extract_lat_lon(f[128])

p <- here::here("~/Desktop/herbivores_ghg/my_corpus")

f1 <- list.files(p, pattern =".pdf$", full.names = TRUE)
f1d{}

map(f1[1:10], extract_lat_lon)

