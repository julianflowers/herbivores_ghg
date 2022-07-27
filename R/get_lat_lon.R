## function to extract lat longs 
# devtools package required to install quanteda from Github 
library(readtext); library(tidyverse);library(quanteda);library(quanteda.tidy)
devtools::install_github("quanteda/quanteda.tidy")
p <- here::here("/Users/julianflowers/Dropbox/My Mac (Julians-MBP-2)/Downloads")

f <- list.files(p, pattern =".pdf$", full.names = TRUE)

corp <- f[c(22, 28, 128)]
corpus <- map_dfr(corp, readtext)

corpus <- tokens(corpus$text)
kwic(corpus, pattern = "\\d{2,}.\\D+[E]", valuetype = "regex") |>
  data.frame()


l <- "58⬚52.3′N, 93⬚41.0′W"
l1 <- "52°86' N, 6°54' W"
l2 <- "458380 N, 28440 E"

str_extract_all(l2, "\\d{2,}.+[NnSs][[:punct:]].\\d{1,}.+")

reg_lat <- "\\d{1,2}.+\\D+[Nn]"
str_extract(l2, reg_lat)

extract_lat_lon <-  function(text){
    
  reg_long <- "\\d{1,2}.\\d{1,2}\\D.+[EW]|\\d{1,6}.\\D+[EW]"
    t <- readtext::readtext(text) 
    out <- str_extract_all(t$text, reg_long)
    out
} 

extract_lat_lon(f[23]) |>
  enframe() |>
  unnest("value") |>
  DT::datatable()

