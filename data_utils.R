get_close_prices <- function(ticker, start_date, end_date) {
  original_start_date <- as.Date(start_date)
  start_date <- original_start_date - lubridate::months(1)
  end_date <- as.Date(end_date)

  stock_data <- quantmod::getSymbols(ticker, src = "yahoo", from = start_date, to = end_date, auto.assign = FALSE)
  close_prices <- quantmod::Cl(stock_data)
  colnames(close_prices) <- "Close"

  df <- data.frame(Date = zoo::index(close_prices), Close = zoo::coredata(close_prices))
  df$Mean <- zoo::rollapply(df$Close, width = 20, FUN = mean, align = "right", fill = NA, na.rm = TRUE)
  df$Sd <- zoo::rollapply(df$Close, width = 20, FUN = sd, align = "right", fill = NA, na.rm = TRUE)
  df$Gap <- (df$Close - df$Mean) / df$Sd
  df$Gause <- dnorm(df$Gap, mean = 0, sd = 0.8)
  return(df[df$Date >= original_start_date, ])
}

get_last_day_rows <- function(df) {
  df$Date <- as.Date(df$Date)
  df %>%
    dplyr::group_by(Year = lubridate::year(Date), Month = lubridate::month(Date)) %>%
    dplyr::filter(Date == max(Date)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-Year, -Month)
}

calculate_irr <- function(cash_flows) {
  tryCatch({
    FinCal::irr(cash_flows) * 100
  }, error = function(e) NA)
}