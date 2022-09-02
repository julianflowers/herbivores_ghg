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


parse_lat_lon

trial <- get_lat_long("my_corpus")


  

trial |>
  select(-c(paras)) |>
  pivot_longer(names_to = "type", values_to = "coords", 2:5) |>
  unnest(coords) |>
  mutate(degrees = ifelse(!type %in% c("dec", "esting"), str_extract_all(coords, "\\d{1,2}"), NA),
         point = ifelse(!type %in% c("dec", "esting"), str_extract(coords, "[nsew]"), NA)) |>
  mutate(row_id = row_number()) |>
  unnest(degrees) |>
  mutate_at("degrees", as.numeric) |>
  group_by(doc_id, row_id) |>
  mutate(dec_coord = degrees[1] + (degrees[2]/60), 
           lat_long = ifelse(point %in% c("n", "s"), "lat", "long")) |>
  slice(1) |>
  select(doc_id, para_id, lat_long, dec_coord) |>
  pivot_wider(names_from = "lat_long",
              values_from = "dec_coord") |>
  ungroup() |>
  fill(lat, .direction = "down") |>
  #fill(long, .direction = "up") |>
  select(-row_id) |>
  distinct()




|>
  gt::gt()
  


decimal_from_deg_min <- function(degrees, minutes, point){
  
  # if(point == "[sS]"|point == "[wW]")
    
    decimal <- degrees + minutes / 60
    
  
  
  return(decimal)

}

decimal_from_en <- function(easting, northing){
  require(jsonlite)
  #uses https://webapps.bgs.ac.uk/data/webservices/convertForm.cfm
  e <- easting
  e <- ifelse(nchar(e) == 5, as.numeric(paste0(e, 0)), e)
  e <- ifelse(nchar(e) == 4, as.numeric(paste0(e, 00)), e)

  n <- northing
  n <- ifelse(nchar(n) == 5, as.numeric(paste0(n, 0)), n)
  n <- ifelse(nchar(n) == 4, as.numeric(paste0(n, 00)), n)
  
  uri <-"https://webapps.bgs.ac.uk/data/webservices/CoordConvert_LL_BNG.cfc?method=BNGtoLatLng"
  
  url <- paste0(uri, "&easting=", e, "&northing=", n)
  
  out <- fromJSON(url)
  lat <- out$LATITUDE[1]
  long <- out$LONGITUDE[1]
  result <- data.frame(lat = lat, long = long)
  
}
  
d <- decimal_from_en(568570, 4835)

df[7, ] |>
  unnest_tokens(para, text, "paragraphs") |>
  gt::gt()

