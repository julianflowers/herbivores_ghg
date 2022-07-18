---
title: "Document driven SS search"
author: "Julian Flowers"
date: '2022-07-18'
output: 
    html_document:  
        toc: yes
        toc_float: yes
        keep_md: yes
    
bibliography: references.bib
---



## Setup

Install and load packages


```r
if(!require("pacman"))install.packages("pacman")
```

```
## Loading required package: pacman
```

```r
p_load_gh("kth-library/semanticscholar", dependencies = TRUE)
p_load(readtext, pdftools, tidytext, quanteda, tidyverse, ggraph, devtools)
```

## Search

@WOS:000784981500002 as starting point


```r
test_ss <- semanticscholar::S2_search_papers("What evidence exists on the impacts of large  herbivores on climate change? A systematic  map protocol")

test_ss$data
```

```
## # A tibble: 3 × 2
##   paperId                                  title                                
## * <chr>                                    <chr>                                
## 1 466446d58e6e5e97e447e88dd9d4b05d4d4b4229 What evidence exists on the impacts …
## 2 e2a4c874abf4ba867d0a34117e8680d0721b1bc8 What evidence exists on the impact o…
## 3 3747e2480fe753db57600b4737fde474d7d72f64 What evidence exists for the impact …
```

## Extract references from each paper


```r
source_url("https://github.com/julianflowers/herbivores_ghg/blob/master/R/get_S2_refs.R?raw=TRUE")
```

```
## ℹ SHA-1 hash of file is 8a21790dcca31206e0ecf54643eec34167545821
```

```r
source_url("https://github.com/julianflowers/herbivores_ghg/blob/master/R/get_S2_citations.R?raw=TRUE")
```

```
## ℹ SHA-1 hash of file is 8e0a581dfba960fea277e3e1ceefc142298196a5
```

```r
safe_refs <- safely(get_S2_refs)
safe_cit <- safely(get_S2_citations)

refs <- map_dfr(test_ss$data$paperId[1], get_S2_refs) 
```

```
## Loading required package: jsonlite
```

```
## 
## Attaching package: 'jsonlite'
```

```
## The following object is masked from 'package:purrr':
## 
##     flatten
```

```
## Loading required package: data.table
```

```
## 
## Attaching package: 'data.table'
```

```
## The following objects are masked from 'package:dplyr':
## 
##     between, first, last
```

```
## The following object is masked from 'package:purrr':
## 
##     transpose
```

```r
cits <- map_dfr(test_ss$data$paperId, get_S2_citations)

glimpse(refs)
```

```
## Rows: 50
## Columns: 3
## $ offset                  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
## $ data.citedPaper.paperId <chr> "15576a01b5e6056684bdb25e7b4df72305803aa8", "1…
## $ data.citedPaper.title   <chr> "Effects of large herbivores on fire regimes a…
```

```r
glimpse(cits)
```

```
## Rows: 3
## Columns: 2
## $ offset <int> 0, 0, 0
## $ data   <list> <NULL>, <NULL>, <NULL>
```

## References
