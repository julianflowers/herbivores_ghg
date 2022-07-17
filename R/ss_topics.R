## function to extract topics (keywords) from articles retrieved by semnatic scholar

get_ss_topics <- function(search){
  
  require(tictoc)
  require(purrr)
  
  tic()
  search <- search
  papers <- semanticscholar::S2_search_papers(search, limit = 100)
  paperId <- papers$data$paperId
  papers1 <- map(paperId, S2_paper)
  topics <- map(papers1, "topics")
  topics <- topics |>
    enframe() |>
    unnest("value") |>
    group_by(name) |>
    summarise(topics = paste(value, collapse = ", "))
  return(topics)
  
  toc()
  
}
