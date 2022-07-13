library(myScrapers); library(gt)

search <- "(facemask* OR face mask[tw] OR PPE) covid transmission systematic[sb]"
ncbi_key <- Sys.getenv("ncbi_key")
n <- 10
start <- 2019
end <- 2022

res <- pubmedAbstractR(search = search, n = n, start = start, end = end, ncbi_key = ncbi_key)

res$abstracts |>
  gt::gt()

sss <- semanticscholar::S2_search_papers("covid facemask transmission systematic review", limit = 100, fields = c("year,abstract,title,venue,referenceCount,citationCount,fieldsOfStudy"))
)

sss$data |>
  gt::gt()

semanticscholar::S2_search_papers(search, limit = 100, fields = c("year,abstract,title,venue,referenceCount,citationCount,fieldsOfStudy"))

get_tldr <- function(ss_id){
  require(jsonlite)
  
  #ss_id = ss_ids[1]
  url <- "https://api.semanticscholar.org/graph/v1/paper/"
  uri <- paste0(url, ss_id, "?fields=tldr")
  
  ext <- fromJSON(uri, simplifyDataFrame=TRUE)
  Sys.sleep(5)
  
}


safe_tldr <- possibly(get_tldr, otherwise = NA_real_)


tldrs <- map(sss$data$paperId[1:10], safe_tldr)

tldrs

