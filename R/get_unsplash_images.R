### get photo images from unsplash API https://api.unsplash.com
### need to register an app as a developer to get api client and secret keys.

get_unsplash_images <- function(search){
  require(jsonlite)
  require(dplyr)
  require(stringr)
  require(magick)
  require(glue)
  
  search <- search
  search <- str_replace_all(search, "\\s", "+")
 # search <- quo(search)
  api_key <- Sys.getenv("UNSPLASH_CLIENT_ID")
  secret <- Sys.getenv("UNSPLASH_CLIENT_SECRET")
  uri <- "https://api.unsplash.com/search/photos"
  
  search_string <- as.character(glue(uri, "?client_id=", api_key, "&client_secret=", secret, "&query=", {search}))
  
  images <- jsonlite::fromJSON(search_string, 
                     , simplifyDataFrame = TRUE)
  images <- image_read(images$results$url$regular)
  
  images
  
  
}


