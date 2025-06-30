source("R/load_packages.R")
source("R/load_data.R")
source("R/feature_engineering.R")
source("R/genetic_algorithm.R")
source("R/evaluation.R")

data <- get_stock_data("AAPL", from = "2015-01-01")
data <- calculate_indicators(data)
plot_result(data)

result <- run_ga(data)