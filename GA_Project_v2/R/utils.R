#-- Utility functions --------------------------------------------------------

# Calculate Internal Rate of Return using FinCal::irr and return in percentage
calculate_irr <- function(cash_flows) {
  tryCatch({
    irr_value <- FinCal::irr(cash_flows) * 100
    return(irr_value)
  }, error = function(e) {
    return(NA_real_)
  })
}

# Simple helper that counts how many values in a numeric vector exceed thresholds
count_investments <- function(vec, thresholds = c(200, 300, 400, 500)) {
  sapply(thresholds, function(th) sum(vec >= th, na.rm = TRUE))
}