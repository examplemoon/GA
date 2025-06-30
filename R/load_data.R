get_stock_data <- function(symbol = "AAPL", from = "2010-01-01", to = Sys.Date()) {
  getSymbols(symbol, src = "yahoo", from = from, to = to, auto.assign = FALSE)
}