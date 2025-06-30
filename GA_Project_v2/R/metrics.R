source("R/utils.R")
source("R/strategies.R")
source("R/data_retrieval.R")

# ---------------------------------------------------------------------------
# Calculate performance metrics for a list of tickers
# ---------------------------------------------------------------------------
calculate_metrics <- function(tickers,
                              years             = 5,
                              risk_free_rate    = 0.02,
                              start_date_global = "2000-01-01",
                              end_date_global   = Sys.Date()) {

  results <- data.frame()

  for (tkr in tickers) {
    df_raw   <- get_close_prices(tkr, start_date_global, end_date_global)
    df_month <- get_last_day_rows(df_raw)

    start_year <- lubridate::year(min(df_month$Date))
    end_year   <- lubridate::year(max(df_month$Date))

    for (st in start_year:(end_year - years + 1)) {
      ed <- st + years

      df_period <- dplyr::filter(
        df_month,
        Date >= as.Date(paste0(st, "-01-01")),
        Date <  as.Date(paste0(ed, "-01-01"))
      )

      if (nrow(df_period) == 0) next

      df_period <- add_VA(df_period)
      df_period <- add_DCA(df_period)
      df_period <- add_GA(df_period)

      # last row metrics
      last_row <- dplyr::slice_tail(df_period, n = 1)

      # Sharpe Ratio (annualized ROI here is approximation)
      sharpe <- function(roi_vec, rf, last_roi) {
        (last_roi - rf * 100) / sd(roi_vec, na.rm = TRUE)
      }

      new_entry <- data.frame(
        Ticker                = tkr,
        Year_Start            = st,
        Last_VA_ROI           = last_row$VA_ROI,
        Last_DCA_ROI          = last_row$DCA_ROI,
        Last_GA_ROI           = last_row$GA_ROI,
        Last_VA_IRR           = last_row$VA_IRR,
        Last_DCA_IRR          = last_row$DCA_IRR,
        Last_GA_IRR           = last_row$GA_IRR,
        Last_VA_Sharpe_Ratio  = sharpe(df_period$VA_ROI,  risk_free_rate, last_row$VA_ROI),
        Last_DCA_Sharpe_Ratio = sharpe(df_period$DCA_ROI, risk_free_rate, last_row$DCA_ROI),
        Last_GA_Sharpe_Ratio  = sharpe(df_period$GA_ROI,  risk_free_rate, last_row$GA_ROI),
        Last_VA_Volatility    = sd(df_period$VA_ROI,  na.rm = TRUE),
        Last_DCA_Volatility   = sd(df_period$DCA_ROI, na.rm = TRUE),
        Last_GA_Volatility    = sd(df_period$GA_ROI,  na.rm = TRUE)
      )

      results <- rbind(results, new_entry)
    }
  }
  results
}