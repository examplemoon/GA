calculate_metrics <- function(tikers, years, rate = 0) {
  result_df <- data.frame()
  for (tiker in tikers) {
    df <- get_close_prices(tiker, "2000-01-01", "2023-08-31")
    df_last <- get_last_day_rows(df)
    start_year <- lubridate::year(min(df_last$Date))
    end_year <- lubridate::year(max(df_last$Date))
    for (start in start_year:(end_year - years + 1)) {
      end <- start + years
      df_period <- dplyr::filter(df_last, Date >= as.Date(paste0(start, "-01-01")) & Date < as.Date(paste0(end, "-01-01")))
      if (nrow(df_period) == 0) next
      df_period <- add_VA(df_period)
      df_period <- add_DCA(df_period)
      df_period <- add_GA(df_period)

      last_idx <- nrow(df_period)
      new_row <- data.frame(
        Ticker = tiker,
        Year_Start = start,
        Last_VA_ROI = df_period$VA_ROI[last_idx],
        Last_DCA_ROI = df_period$DCA_ROI[last_idx],
        Last_GA_ROI = df_period$GA_ROI[last_idx],
        Last_VA_IRR = df_period$VA_IRR[last_idx],
        Last_DCA_IRR = df_period$DCA_IRR[last_idx],
        Last_GA_IRR = df_period$GA_IRR[last_idx],
        Last_VA_Sharpe_Ratio = (df_period$VA_ROI[last_idx] - rate) / sd(df_period$VA_ROI, na.rm = TRUE),
        Last_DCA_Sharpe_Ratio = (df_period$DCA_ROI[last_idx] - rate) / sd(df_period$DCA_ROI, na.rm = TRUE),
        Last_GA_Sharpe_Ratio = (df_period$GA_ROI[last_idx] - rate) / sd(df_period$GA_ROI, na.rm = TRUE),
        Last_VA_volatility = sd(df_period$VA_ROI, na.rm = TRUE),
        Last_DCA_volatility = sd(df_period$DCA_ROI, na.rm = TRUE),
        Last_GA_volatility = sd(df_period$GA_ROI, na.rm = TRUE)
      )
      result_df <- rbind(result_df, new_row)
    }
  }
  return(result_df)
}