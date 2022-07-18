## get S2 citations

get_S2_citations <- function(paperId){

  require(semanticscholar)
  require(jsonlite)
  require(data.table)
  
  api <- S2_api()
  url <- paste0(api, "graph/v1/paper/", paperId, "/citations")
  cit <- fromJSON(url, simplifyDataFrame=TRUE)
  cit <- as.data.table(cit) 
  
}

