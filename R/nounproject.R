devtools::install_github("CaRdiffR/nounprojectR")
library(nounprojectR)
nounprojectR::np_credentials("ecology", "4e1dec60dae2482dadd228c2ad566290", 
                             "4f0196c0980045afb9034299a98e35ce")

cow <- nounprojectR::get_icon_by_term("cow")

glimpse(sheep)

sheep$icons

sheep |>
  enframe() |>
  unnest("value")

sheep_icons <- map(sheep$icons, c("icon_url")) 

browseURL(sheep_icons[[4]])

library(rvest); library(httr)

uri <- "https://api.unsplash.com/search/photos"

get_unsplash_images <- function(search_string){
search_string <- str_replace_all(search_string, "\\s", "+")
client_id <- Sys.getenv("UNSPLASH_CLIENT_ID")
url <- paste0("https://api.unsplash.com/search/photos?client_id=sLuCjP0RHH6f3SazTduv_rCFtXEcb7XCU_1sg8nKoS0&query=", search_string)
url1 <- paste0("https://api.unsplash.com/search/photos?client_id=", client_id, "&query=", search_string)

identical(url, url1)

x1 <- jsonlite::fromJSON(url, simplifyDataFrame = TRUE)

images <- magick::image_read(head(x1$results$urls$small))
}

i <- get_unsplash_images("willow tit")

str(i)

i[1]
