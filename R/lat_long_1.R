get_lat_long <- function(corpus){
  
  require(readtext)
  require(here)
  require(tidytext)
#  corpus <- "my_corpus"
  path <- here::here(corpus)   ## point R at the pdf directory 
  
  f <- list.files(p, "pdf$", full.names = T)         ## get a list of files
  
  df <- map_dfr(f, readtext)        ## read files into a dataframe
  
  df1 <- df |>
     unnest_tokens(paras, text, "sentences")
  
  df1 
  
  p1 <- "\\d{1,2}\\D*◦\\D?\\d{1,2}\\D*[NSEWnsew]|\\d{1,2}\\D*°\\D?\\d{1,2}\\D*[NSEWnsew]"   ## generic pattern
  
  p2 <- "\\d{1,2}\\.\\d{1,2}.?◦.?[NSEWnsew]|\\d{1,2}\\.\\d{1,2}.?°.?[NSEWnsew]"     ## decimal coordinates
  
  p3 <-  "[NSEWnsew]\\d{1,2}:\\d{1,2}:\\d{1,2}?"                                   ## colon separated
  
  p4 <- "\\d{4,6}\\D?[NSns].*\\d{4,6}\\D?[EWew]"                                                    ## easting / northing
  
  
  p5 <- "(\\d{1,2})(◦|°|\\.||8?|:|\024.)?(\\D*)?(\\d{1,2}|\\d{1,2}′|\\d{1,2}\004).*([NSEWnsew])"

matches <- df1 |>
  mutate(matches = map(paras, ~str_extract_all(.x, paste0(p1, "|", p2, "|", p3, "|", p4)))) |>
  unnest("matches") |>
  pluck("matches") 

map(matches, ~nchar(.x) >0)

str_match(matches, p5) |>
  data.frame()

deg_coord <- matches |>
  mutate(match = map(matches, str_match_all, p5))  |>
  gt::gt()

deg_coord |>
  DT::datatable()
  
  set_names(c("extract", "degrees", "symbol", "space", "minutes", "point")) |>
  mutate_at(.vars = c("degrees", "minutes"), as.numeric) |>
  mutate(decimal_coords = ifelse(str_detect(symbol, "\\."), degrees + minutes/100, degrees + minutes/60),
         decimal_coords = ifelse(str_detect(point, "[SsWw]"), decimal_coords * -1, decimal_coords), 
         lat_long = case_when(str_detect(point, "[NnSs]") ~ "lat", 
                              str_detect(point, "[EeWw]" ) ~ "long")) 


}


test <- get_lat_long("my_corpus")

test
  