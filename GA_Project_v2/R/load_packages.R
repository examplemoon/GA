required_packages <- c(
  "knitr", "lattice", "zoo", "quantmod",
  "dplyr", "lubridate", "ggplot2", "ggpubr",
  "gridExtra", "FinCal", "stringr", "tidyverse"
)

load_libraries <- function() {
  for (pkg in required_packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
      library(pkg, character.only = TRUE)
    }
  }
}

load_libraries()