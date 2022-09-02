library(here); library(pdftools); library(tidyverse)

p <- here::here("my_corpus")

pdfs <- list.files(p, ".pdf$", full.names = T)

pdfs

safe_pdf <- safely(pdf_text)

pdfText <- map(pdfs, ~safe_pdf(.x))
result <- map(pdfText, "result")
names(result) <- basename(pdfs)

result

map_dbl(result, length)

result_1 <- map_dfr(result, ~bind_rows(.x, .id = names(result))

head(result_1)

result_1[[1]]

result[1]

dim(result)

glimpse(result)
  
decimal_pattern <- "\\d{1,2}\\.\\d{1,2}◦.*[NSEW]|[NSEW]\\d{1,2}\\.\\d{1,2}◦|\\d{1,2}\\.\\d{1,2}°.*[NSEW]|[NSEW]\\d{1,2}\\.\\d{1,2}°"

colon_pattern <- "[NSEW]?\\d{1,2}:\\d{1,2}:\\d{1,2}?"

normal_pattern <- "\\d{1,2}.*◦\\D?\\d{1,2}.*[NSEW]|\\d{1,2}.*°\\D?\\d{1,2}.*[NSEW]"

alt_pattern <- "\\d{1,2}.?\\d{1,2}.?[[:punct:]][NSEW]"

degrees <- "\\d{1,2}\\D?(?=◦)|\\d{1,2}\\D?(?=°)"
decimal_coords <- "\\d{1,2}\\.\\d{1,2}(?=◦)|\\d{1,2}\\.\\d{1,2}(?=°)"
minutes <- "\\d{1,2}\\D?(?=ʹ)|\\d{1,2}\\D?(?=')"

str(result)

result %>%
  mutate(value = str_squish(value),
         normal = str_match_all(value, degrees)) |>
  unnest("normal") |>
  drop_na() |>
  select(normal)
  


look_test |>
  enframe() |>
  unnest("value")

|>
  unnest("degrees") |>
  DT::datatable()

## Extract potentiallat longs

x <- pdfs |>
  mutate(dec = str_extract_all(text, decimal_pattern), 
         colon = str_extract_all(text, colon_pattern), 
         normal = str_extract_all(text, normal_pattern), 
         alt = str_extract_all(text, alt_pattern), 
         degrees = str_extract_all(text, alt1)) |>
  select(doc_id, dec, colon, normal, alt, degrees)

  
  
x

pdfs |>
  filter(str_detect(doc_id, "0871")) |>
  select(text) |>
  str_squish()

x |>
  unnest("degrees")

## Parse into decimal coordinates

df1 <- x |>
  hoist("normal") |>
  hoist("dec") |>
  hoist("colon") |>
  pivot_longer(names_to = "pattern", values_to = "coords", 2:4) |>
  unnest("coords") |>
  mutate(degree = ifelse(pattern == "normal", str_extract_all(coords, "\\d{1,2}?°|\\d{1,2}?◦"),
                         ifelse(pattern == "colon", str_extract(coords, "\\d{1,2}:"), 
                                str_extract_all(coords, "\\d{1,2}\\.\\d{1,2}"))),
         minutes = ifelse(pattern == "normal", str_extract_all(coords, "°\\d{1,2}|◦\\d{1,2}"),
                          ifelse(pattern == "colon", str_extract(coords, ":\\d{1,2}"), coords)),
  ) |>
  unnest("degree") |>
  unnest("minutes") |>
  mutate(degree = parse_number(degree),
         minutes = parse_number(minutes),
         decimal = ifelse(pattern != "dec", degree + (minutes/60), degree), 
         decimal = round(decimal, 4), 
         point = str_extract_all(coords, "[NSEW]")) |>
  unnest("point") |>
  mutate(lat_long = case_when(decimal < 10 & point %in% c("E", "W") ~"long", 
                              decimal > 10 & point %in% c("N", "S") ~ "lat", 
  )) |>
  drop_na() |>
  mutate(
    decimal = ifelse(point == "W", -decimal, decimal)
  ) |>
  distinct() 


