#-- Price retrieval and preprocessing ---------------------------------------

get_close_prices <- function(ticker,
                             start_date = "2000-01-01",
                             end_date   = Sys.Date()) {

  original_start <- as.Date(start_date)

  # pull additional month so that rolling window (20d) is available
  query_start    <- original_start - lubridate::months(1)
  query_end      <- as.Date(end_date)

  quantmod::getSymbols(
    ticker, src = "yahoo",
    from = query_start, to = query_end,
    auto.assign = FALSE
  ) -> price_xts

  # Close price to data.frame
  df <- data.frame(
    Date  = zoo::index(quantmod::Cl(price_xts)),
    Close = zoo::coredata(quantmod::Cl(price_xts)),
    row.names = NULL
  )

  # Rolling mean & std‑dev (20 trading days)
  df$Mean <- zoo::rollapply(df$Close, 20, mean, align = "right", fill = NA, na.rm = TRUE)
  df$Sd   <- zoo::rollapply(df$Close, 20, sd,   align = "right", fill = NA, na.rm = TRUE)

  # Z‑score gap & Gaussian weight
  df$Gap   <- with(df, (Close - Mean) / Sd)
  df$Gause <- stats::dnorm(df$Gap, mean = 0, sd = 0.8)

  # Keep rows after the true start date
  dplyr::filter(df, Date >= original_start)
}

# Extract last trading day of each month
get_last_day_rows <- function(df) {
  df %>%
    dplyr::mutate(Date = as.Date(Date)) %>%
    dplyr::group_by(Year = lubridate::year(Date),
                    Month = lubridate::month(Date)) %>%
    dplyr::filter(Date == max(Date)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-Year, -Month)
}