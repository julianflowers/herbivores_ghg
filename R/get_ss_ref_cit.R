## get semantic scholar references from ss graph api

get_ss_refs <- function(id){
  
  
  require(jsonlite)
  uri <- paste0("https://partner.semanticscholar.org/graph/v1/paper/", id, "/references")
  out <- fromJSON(uri, simplifyDataFrame = TRUE)
  
  
  
}

r <- get_ss_refs("466446d58e6e5e97e447e88dd9d4b05d4d4b4229")
r


get_ss_citations <- function(id){
  
  
  require(jsonlite)
  uri <- paste0("https://partner.semanticscholar.org/graph/v1/paper/", id, "/citations")
  out <- fromJSON(uri, simplifyDataFrame = TRUE)
  
  
  
}

x <- get_ss_citations("ffc4498e3df896ddf5aa5d8d020a2767008aa8f9")
x
