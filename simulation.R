# 시뮬레이션: 다양한 시나리오에 따른 투자전략 비교
set.seed(123)

start_date <- as.Date("2000-01-01")
end_date <- as.Date("2002-09-26")
dates <- seq.Date(from = start_date, to = end_date, by = "day")

n <- 1000
initial_price <- 100
growth_rate_up <- 0.3
growth_rate_down <- -0.23077
quarter_n <- n / 4

scenarios <- list(
  c("up", "up", "up", "up"), c("up", "up", "up", "down"), c("up", "up", "down", "up"),
  c("up", "down", "up", "up"), c("down", "up", "up", "up"), c("up", "up", "down", "down"),
  c("up", "down", "up", "down"), c("up", "down", "down", "up"), c("down", "down", "up", "up"),
  c("down", "up", "up", "down"), c("down", "up", "down", "up"), c("up", "down", "down", "down"),
  c("down", "up", "down", "down"), c("down", "down", "up", "down"), c("down", "down", "down", "up"),
  c("down", "down", "down", "down")
)
colors <- c(rep("blue", 5), rep("black", 6), rep("red", 5))

results <- data.frame()
plots <- list()

for (index in 1:length(scenarios)) {
  scenario <- scenarios[[index]]
  color <- colors[index]

  prices <- numeric(n)
  prices[1] <- initial_price
  price_changes <- numeric(5)
  price_changes[1] <- initial_price

  for (i in 1:4) {
    start_index <- (i - 1) * quarter_n + 1
    end_index <- i * quarter_n
    if (i > 1) prices[start_index] <- prices[start_index - 1]
    prices[start_index:end_index] <- seq(
      from = prices[start_index],
      to = prices[start_index] * (1 + ifelse(scenario[i] == "up", growth_rate_up, growth_rate_down)),
      length.out = quarter_n
    )
    price_changes[i + 1] <- prices[end_index]
  }

  df <- data.frame(Date = dates[1:n], Close = prices)
  df$Mean <- zoo::rollapply(df$Close, width = 20, FUN = mean, align = "right", fill = NA)
  df$Sd <- zoo::rollapply(df$Close, width = 20, FUN = sd, align = "right", fill = NA)
  df$Gap <- (df$Close - df$Mean) / df$Sd
  df$Gause <- dnorm(df$Gap, mean = 0, sd = 0.8)

  df_last <- get_last_day_rows(df)
  df_last <- add_VA(df_last)
  df_last <- add_DCA(df_last)
  df_last <- add_GA(df_last)

  last_row <- df_last[nrow(df_last), ]
  summary_df <- data.frame(
    Scenario = paste(scenario, collapse = "-"),
    Price_Changes = paste(round(price_changes, 2), collapse = "-"),
    VA_ROI = last_row$VA_ROI,
    VA_IRR = last_row$VA_IRR,
    DCA_ROI = last_row$DCA_ROI,
    DCA_IRR = last_row$DCA_IRR,
    GA_ROI = last_row$GA_ROI,
    GA_IRR = last_row$GA_IRR,
    VA_Sharpe = last_row$VA_ROI / sd(df_last$VA_ROI, na.rm = TRUE),
    DCA_Sharpe = last_row$DCA_ROI / sd(df_last$DCA_ROI, na.rm = TRUE),
    GA_Sharpe = last_row$GA_ROI / sd(df_last$GA_ROI, na.rm = TRUE),
    VA_Volatility = sd(df_last$VA_ROI, na.rm = TRUE),
    DCA_Volatility = sd(df_last$DCA_ROI, na.rm = TRUE),
    GA_Volatility = sd(df_last$GA_ROI, na.rm = TRUE),
    VA_mean_Period_Invest = mean(df_last$VA_Period_Invest, na.rm = TRUE),
    DCA_mean_Period_Invest = mean(df_last$DCA_Period_Invest, na.rm = TRUE),
    GA_mean_Period_Invest = mean(df_last$GA_Period_Invest, na.rm = TRUE),
    VA_std_Period_Invest = sd(df_last$VA_Period_Invest, na.rm = TRUE),
    DCA_std_Period_Invest = sd(df_last$DCA_Period_Invest, na.rm = TRUE),
    GA_std_Period_Invest = sd(df_last$GA_Period_Invest, na.rm = TRUE),
    VA_Average_Cost = last_row$VA_Average_cost,
    DCA_Average_Cost = last_row$DCA_Average_cost,
    GA_Average_Cost = last_row$GA_Average_cost
  )

  results <- rbind(results, summary_df)
  write.csv(summary_df, paste0("summary_results_", index, ".csv"), row.names = FALSE)
  write.csv(df_last, paste0("df_last_", index, ".csv"), row.names = FALSE)

  p <- ggplot2::ggplot(df, ggplot2::aes(x = Date, y = Close)) +
    ggplot2::geom_line(color = color) +
    ggplot2::labs(x = "Date", y = "Close Price") +
    ggplot2::theme_minimal()
  plots[[index]] <- p
}

do.call(gridExtra::grid.arrange, c(plots, ncol = 4))
print(results)
write.csv(results, "rlt.csv")