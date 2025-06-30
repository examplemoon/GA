add_VA <- function(df) {
  df$VA_Value_Required <- seq(from = 100, by = 100, length.out = nrow(df))
  df$VA_Shares_Owned <- df$VA_Value_Required / df$Close
  df$VA_Shares_Bought <- c(df$VA_Shares_Owned[1], diff(df$VA_Shares_Owned))
  df$VA_Period_Invest <- df$VA_Shares_Bought * df$Close
  df$VA_Invest_total <- cumsum(df$VA_Period_Invest)
  df$VA_Average_cost <- df$VA_Invest_total / df$VA_Shares_Owned
  df$VA_ROI <- (df$VA_Value_Required - df$VA_Invest_total) / df$VA_Invest_total * 100
  df$VA_IRR <- NA_real_
  for (i in seq_len(nrow(df))) {
    if (i > 1) {
      df$VA_IRR[i] <- calculate_irr(c(-df$VA_Period_Invest[1:(i-1)], df$VA_Value_Required[i] - df$VA_Period_Invest[i]))
    }
  }
  df
}

add_DCA <- function(df) {
  df$DCA_Period_Invest <- 100
  df$DCA_Shares_Bought <- df$DCA_Period_Invest / df$Close
  df$DCA_Shares_Owned <- cumsum(df$DCA_Shares_Bought)
  df$DCA_Value <- df$Close * df$DCA_Shares_Owned
  df$DCA_Invest_Total <- cumsum(df$DCA_Period_Invest)
  df$DCA_Average_cost <- df$DCA_Invest_Total / df$DCA_Shares_Owned
  df$DCA_ROI <- (df$DCA_Value - df$DCA_Invest_Total) / df$DCA_Invest_Total * 100
  df$DCA_IRR <- NA_real_
  for (i in seq_len(nrow(df))) {
    if (i > 1) {
      df$DCA_IRR[i] <- calculate_irr(c(-df$DCA_Period_Invest[1:(i-1)], df$DCA_Value[i] - df$DCA_Period_Invest[i]))
    }
  }
  df
}

add_GA <- function(df) {
  df$GA_Period_Invest <- df$VA_Period_Invest * df$Gause + df$DCA_Period_Invest * (1 - df$Gause)
  df$GA_Shares_Bought <- df$GA_Period_Invest / df$Close
  df$GA_Shares_Owned <- cumsum(df$GA_Shares_Bought)
  df$GA_Invest_total <- cumsum(df$GA_Period_Invest)
  df$GA_Average_cost <- df$GA_Invest_total / df$GA_Shares_Owned
  df$GA_Value <- df$GA_Shares_Owned * df$Close
  df$GA_ROI <- (df$GA_Value - df$GA_Invest_total) / df$GA_Invest_total * 100
  df$GA_IRR <- NA_real_
  for (i in seq_len(nrow(df))) {
    if (i > 1) {
      df$GA_IRR[i] <- calculate_irr(c(-df$GA_Period_Invest[1:(i-1)], df$GA_Value[i] - df$GA_Period_Invest[i]))
    }
  }
  df
}