## get lat longs from text/pdfs

get_lat_long <- function(corpus){
  
  require(readtext)
  require(here)
  require(tidytext)

  path <- here::here(corpus)   ## point R at the pdf directory 
  
  f <- list.files(p, "pdf$", full.names = T)         ## get a list of files
  
  df <- map_dfr(f, readtext)        ## read files into a dataframe
  
  df <- df |>
    unnest_tokens(paras, text, "paragraphs")
  
  
  p1 <- "\\d{1,2}\\D*◦\\D?\\d{1,2}\\D*[NSEWnsew]|\\d{1,2}\\D*°\\D?\\d{1,2}\\D*[NSEWnsew]"   ## generic pattern
   
  p2 <- "\\d{1,2}\\.\\d{1,2}.?◦.?[NSEWnsew]|\\d{1,2}\\.\\d{1,2}.?°.?[NSEWnsew]"     ## decimal coordinates
  
  p3 <-  "[NSEWnsew]?\\d{1,2}:\\d{1,2}:\\d{1,2}?"                                   ## colon separated
  
  p4 <- "\\d{4,6}\\D?[NSns].*\\d{4,6}\\D?[EWew]"                                                    ## easting / northing
  
  df <- df |>
    mutate(paras = str_remove_all(paras, "◦[Cc]|°[Cc]"))
  
  df <- df |>
    mutate(gen = str_extract_all(paras, p1))
  
  df <- df |>
    mutate(dec = str_extract_all(paras, p2))
  
  df <- df |>
    mutate(colon = str_extract_all(paras, p3))
  
  
  df <- df |>
    mutate(esting = str_extract_all(paras, p4))
  
  df <- df |>
    group_by(doc_id) |>
    mutate(para_id = row_number())
  
  df <- df |>
    select(-c(paras)) |>
    pivot_longer(names_to = "type", values_to = "coords", 2:5) |>
    unnest(coords) |>
    mutate(degrees = ifelse(!type %in% c("dec", "esting"), str_extract_all(coords, "\\d{1,2}"), NA), 
           point = ifelse(!type %in% c("dec", "esting")))
  
}


