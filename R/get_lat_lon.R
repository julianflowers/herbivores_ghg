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
l3 <- "The pilot study area measured c. 126 × 132 km, centred on Madrid province, Spain, with the lower right co-ordinate at 2°44′ W, 39°49′ N (Fig. 1). It was chosen because accurate great bustard census data, geographic information system (GIS) data coverages and satellite imagery were readily available. The area comprised 55·9% agricultural land, 29·2% natural scrub or wooded cover, 8·2% forestry, 5·6% built environment and the remaining 1·1% bare ground or open water (European Union Corine Land Cover Project). The majority of analyses were confined to Madrid province itself because this was where bustard censuses were conducted but, where possible, models were extrapolated to the full study area (see later)."

str_extract_all(l3, "\\d{2,}.+[NnSs][[:punct:]].\\d{1,}.+")

reg_lat <- "\\d{1,2}.+\\D+[Nn]"
str_extract(l3, tt)

tt <- "(?(\\d+)°)?(?:(\\d+)')?(?(\\d+)\\.)?"

extract_lat_lon <-  function(text){
    
  reg_long <- "\\d{1,2}.\\d{1,2}\\D.+[EW]|\\d{1,6}.\\D+[EW]"
    t <- readtext::readtext(text) 
    out <- str_extract_all(t$text, reg_long)
    out
} 

ll <- "^([+-]?\\d{1,3}\\*?\\s+\\d{1,2}'?\\s+\\d{1,2}+?[NSEW]?|\\d{1,3}(\\d{2}){2}\\.\\d[NSEW]\\s*){1,2}$"
extract_lat_lon(l3)

extract_lat_lon(f[23]) |>
  enframe() |>
  unnest("value") |>
  DT::datatable()

