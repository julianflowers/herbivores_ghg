library(pdftools);library(tidyverse)
path <- here::here("my_corpus")   ## point R at the pdf directory 

f <- list.files(path, "pdf$", full.names = T)         ## get a list of files
f %>%
  str_detect(., "3736")

p1 <- "\\d{1,2}\\D*◦\\D?\\d{1,2}\\D*[NSEWnsew]|\\d{1,2}\\D*°\\D?\\d{1,2}\\D*[NSEW]"   ## generic pattern

p2 <- "\\d{1,2}\\.\\d{1,2}.?◦.?[NSEWnsew]|\\d{1,2}\\.\\d{1,2}.?°.?[NSEWnsew]"     ## decimal coordinates

p3 <-  "[NSEWnsew]\\d{1,2}:\\d{1,2}:\\d{1,2}?"                                   ## colon separated

p4 <- "\\d{4,6}\\D?[NSns].*\\d{4,6}\\D?[EWew]"                                                    ## easting / northing


p5 <- "((\\d{1,2})(◦|°|\\.||8?|:|\\\\))(\\D*)(\\d{1,2}|\\d{1,2}′|\\d{1,2}\\004)(\\D*)([NSEW])"

p6 <- "(\\d{1,2}(◦|°|\\.||8?|:|\\001))"

p7 <- "(\\d{1,2})\\D{1,4}(\\d{1,2}0)\\D{1,3}(\\d{1,2}00)\\s*([NSEWnsew])"



f[32]

x <- map(f, pdftools::pdf_text)
x <- map_dfr(x, enframe)

y <- map_dfr(f, readtext::readtext)

head(y)
 
x[[2]]
str(x)
x[1:2,] |>
  mutate(match = str_match_all(value, p5)) |>
  unnest_auto("match") |>
  DT::datatable()
  

pat1 <- y |>
  mutate(text = str_squish(text),
         matches = str_match_all(text, p1)) |>
  select(-text) |>
  unnest_wider("matches") 

pat2 <- y |>
  mutate(text = str_squish(text),
         matches = str_match_all(text, p2)) |>
  select(-text) |>
  unnest_longer("matches") |>
  reactable::reactable()

pat3 <- y |>
  mutate(text = str_squish(text),
         matches = str_match_all(text, p3)) |>
  select(-text) |>
  unnest_longer("matches") |>
  reactable::reactable()
   
pat7 <- y |>
  mutate(text = str_squish(text),
         matches = str_match_all(text, p7)) |>
  select(-text) |>
  unnest_wider("matches") 

pat5 <- y |>
  mutate(text = str_squish(text),
         matches = str_match_all(text, p5)) |>
  select(-text) |>
  unnest_wider("matches") 

str_match_all(y$text, p3) |>
  tibble() |>
  set_names("base") |>
  unnest_longer("base") |>
  data.frame() |>
  View()



|>
  set_names("X1", "X2", "X3", "X4", 
            "X5", "X6", "X7", "X8")
  


|>
  DT::datatable()

pat5 |> 
  reactable::reactable()

|>
  data.frame() |>
  set_names("X1") |>
  mutate(matches = str_match_all(X1, p5)) |>
  reactable::reactable()
