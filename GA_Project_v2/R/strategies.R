source("R/utils.R")   # for calculate_irr

#-- 1. Value Averaging -------------------------------------------------------
add_VA <- function(df, target_increment = 400) {
  n <- nrow(df)
  df$VA_Value_Required <- seq(from = target_increment,
                              by   = target_increment,
                              length.out = n)

  df$VA_Shares_Owned  <- df$VA_Value_Required / df$Close
  df$VA_Shares_Bought <- c(df$VA_Shares_Owned[1],
                           diff(df$VA_Shares_Owned))

  df$VA_Period_Invest <- df$VA_Shares_Bought * df$Close

  # cumulative values
  df$VA_Invest_total  <- cumsum(df$VA_Period_Invest)

  # Average cost, ROI & IRR
  df$VA_Average_cost  <- cummean(df$VA_Period_Invest)
  df$VA_Value         <- df$Close * df$VA_Shares_Owned
  df$VA_ROI           <- (df$VA_Value - df$VA_Invest_total) / df$VA_Invest_total * 100

  # IRR per row
  df$VA_IRR <- NA_real_
  for (i in seq_len(n)) {
    cash_flows <- c(-df$VA_Period_Invest[1:i-1],
                     df$VA_Value[i] - df$VA_Period_Invest[i])
    df$VA_IRR[i] <- calculate_irr(cash_flows)
  }
  df
}

#-- 2. Dollar Cost Averaging -------------------------------------------------
add_DCA <- function(df, invest_per_period = 400) {
  n <- nrow(df)
  df$DCA_Period_Invest <- rep(invest_per_period, n)
  df$DCA_Shares_Bought <- invest_per_period / df$Close
  df$DCA_Shares_Owned  <- cumsum(df$DCA_Shares_Bought)
  df$DCA_Value         <- df$Close * df$DCA_Shares_Owned

  # cumulative
  df$DCA_Invest_total  <- cumsum(df$DCA_Period_Invest)
  df$DCA_Average_cost  <- df$DCA_Invest_total / df$DCA_Shares_Owned
  df$DCA_ROI           <- (df$DCA_Value - df$DCA_Invest_total) / df$DCA_Invest_total * 100

  df$DCA_IRR <- NA_real_
  for (i in seq_len(n)) {
    cash_flows <- c(-df$DCA_Period_Invest[1:i-1],
                     df$DCA_Value[i] - df$DCA_Period_Invest[i])
    df$DCA_IRR[i] <- calculate_irr(cash_flows)
  }
  df
}

#-- 3. Hybrid GA Strategy ----------------------------------------------------
add_GA <- function(df) {
  n <- nrow(df)

  # Period invest derived from Gaussian weight between VA & DCA
  df$GA_Period_Invest <- df$VA_Period_Invest * df$Gause +
                         df$DCA_Period_Invest * (1 - df$Gause)

  df$GA_Shares_Bought <- df$GA_Period_Invest / df$Close
  df$GA_Shares_Owned  <- cumsum(df$GA_Shares_Bought)
  df$GA_Value         <- df$Close * df$GA_Shares_Owned

  df$GA_Invest_total  <- cumsum(df$GA_Period_Invest)
  df$GA_Average_cost  <- df$GA_Invest_total / df$GA_Shares_Owned
  df$GA_ROI           <- (df$GA_Value - df$GA_Invest_total) / df$GA_Invest_total * 100

  df$GA_IRR <- NA_real_
  for (i in seq_len(n)) {
    cash_flows <- c(-df$GA_Period_Invest[1:i-1],
                     df$GA_Value[i] - df$GA_Period_Invest[i])
    df$GA_IRR[i] <- calculate_irr(cash_flows)
  }

  df
}