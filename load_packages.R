required_packages <- c(
  "knitr", "lattice", "zoo", "quantmod", "dplyr", "lubridate",
  "ggplot2", "FinCal", "stringr", "tidyverse", "ggpubr", "gridExtra"
)

load_libraries <- function() {
  for (pkg in required_packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    }
  }
}

load_libraries()