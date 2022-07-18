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
p_load_gh("kth-library/semanticscholar", dependencies = TRUE)
p_load(readtext, pdftools, tidytext, quanteda, tidyverse, ggraph)
```

## Search

@Conant2017GrasslandMI as starting point


```r
test_ss <- semanticscholar::S2_search_papers("Grassland management impacts on soil carbon stocks: a new synthesis.")

test_ss$data
```

```
## # A tibble: 2 × 2
##   paperId                                  title                                
## * <chr>                                    <chr>                                
## 1 5a8b41f8b2a7eec479bc34afedf5af7d564ed280 Grassland management impacts on soil…
## 2 e499ceebec4c712b9f0f631dbcfa5456afb54e3a On the impact of grassland managemen…
```

## References
