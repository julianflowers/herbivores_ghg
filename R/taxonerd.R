install.packages("https://github.com/nleguillarme/taxonerd/releases/download/v1.3.0/taxonerd_for_R_1.3.0.tar.gz", repos=NULL)
library(pacman)
p_load(tidyverse, taxonerd, reticulate)

virtualenv_install("r_taxonerd", packages = "taxonerd[1.3.2]")
import("taxonerd")

use_python(install_python(version="3.8:latest", force = TRUE))
use_virtualenv("")
               