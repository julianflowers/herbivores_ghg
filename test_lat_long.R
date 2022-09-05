library(pdftools);library(tidyverse)
path <- here::here("my_corpus")   ## point R at the pdf directory 

f <- list.files(path, "pdf$", full.names = T)         ## get a list of files
f %>%
  str_detect(., "3736")

p1 <- "\\d{1,2}\\D*◦\\D?\\d{1,2}\\D*[NSEWnsew]|\\d{1,2}\\D*°\\D?\\d{1,2}\\D*[NSEW]"   ## generic pattern

p2 <- "\\d{1,2}\\.\\d{1,2}.?◦.?[NSEWnsew]|\\d{1,2}\\.\\d{1,2}.?°.?[NSEWnsew]"     ## decimal coordinates

p3 <-  "[NSEWnsew]\\d{1,2}:\\d{1,2}:\\d{1,2}?"                                   ## colon separated

p4 <- "\\d{4,6}\\D?[NSns].*\\d{4,6}\\D?[EWew]"                                                    ## easting / northing


p5 <- "(\\d{1,2})(◦|°|\\.||8?|:|\\\\)(\\s*)(\\d{1,2}|\\d{1,2}′|\\d{1,2}\\004)(.*)([NSEW])"

p6 <- "(\\d{1,2})(◦|°|\\.||8?|:|\\001)"

p7 <- "(\\d{1,2})\\D*(\\d{1,2}0)\\D*(\\d{1,2}00)\\D*([NSEWnsew])"



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
  

y[31,]$text |>
  str_squish() |>
  str_match_all(p1) |>
  data.frame() |>
  set_names("X1") |>
  mutate(matches = str_match_all(X1, p5)) |>
  reactable::reactable()
