## function to retrieve tl;dr summaries from semantic scholar searched

get_tldr <- function(ss_id){
  require(jsonlite)
  require(purrr)
  
  #ss_id = ss_ids[1]
  url <- "https://api.semanticscholar.org/graph/v1/paper/"
  uri <- paste0(url, ss_id, "?fields=tldr")
  
  ext <- fromJSON(uri, simplifyDataFrame=TRUE)
  Sys.sleep(5)
  
}


safe_tldr <- possibly(get_tldr, otherwise = NA_real_)

