
remove.packages(reticulate)
install.packages("https://github.com/nleguillarme/taxonerd/releases/download/v1.5.0/taxonerd_for_R_1.5.0.tar.gz", repos=NULL)

library(taxonerd);library(rplos);library(reticulate)

virtualenv_list()
virtualenv_remove("r-taxonerd")
virtualenv_create("r-taxonerd")
use_virtualenv("r-taxonerd")
import("nmslib")
py_install("taxonerd", pip = TRUE, envname = "r-taxonerd")
reticulate::use_python("/Users/julianflowers/.virtualenvs/r-taxonerd/bin/python") ## restart R after running this line of code

taxonerd <- import("taxonerd")


install.model(model="en_core_eco_weak_biobert", version = "1.0.0")


reticulate::import("util")

taxone

taxonerd <- init.taxonerd(model = "en_core_eco_weak_biobert", exclude=list("tagger", "attribute_ruler", "parser"), linker="taxref", thresh=0.7, gpu=TRUE)

corpus_dir <- "./my~corpus"

dir.create(corpus_dir, showWarnings = FALSE)
# Get DOIs for full article in PLoS One
res <- searchplos('biodiversity AND urban AND forest', c('id','publication_date','title'), list('subject:ecology', 'journal_key:PLoSONE','doc_type:full'), limit = 10)
# Download full-text articles in PDF format
for (doi in res$data$id) {
  pdf.url <- gsub("manuscript", "printable", full_text_urls(doi=doi))
  dest.file <- file.path(corpus_dir, paste(gsub("/", "_", doi), "pdf", sep="."))
  download.file(pdf.url, dest.file)
  
}

out <- list.files(corpus_dir, full.names = TRUE)

list.of.dfs <- find.in.file(taxonerd, out[1])

tmpdir<- tempdir()

find.in.corpus(taxonerd, input.dir.path = corpus_dir, output.dir.path = tmpdir)

ann <- list.files(tmpdir, "ann", full.names = TRUE)

read_delim(ann[1], col_names = FALSE)
