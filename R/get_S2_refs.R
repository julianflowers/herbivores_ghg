## get S2 refs

get_S2_refs <- function(paperId){
  
  require(semanticscholar)
  require(jsonlite)
  require(data.table)
  api <- S2_api()
  url <- paste0(api, "graph/v1/paper/", paperId, "/references")
  refs <- fromJSON(url, simplifyDataFrame=TRUE)
  refs <- as.data.table(refs) 
}