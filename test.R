# ---- load environment ----
source("R/load_packages.R")
source("R/data_utils.R")
source("R/strategies.R")

# ============================================================
# 5. TEST
# ============================================================

# ------------------------------------------------------------
# 5.0 Synthetic downward trend example
# ------------------------------------------------------------
example_df <- data.frame(
  Period = 1:5,
  Close  = c(100, 70, 49, 35, 24)
)

example_df <- add_VA(example_df)
example_df <- add_DCA(example_df)

print("Synthetic example with VA & DCA added:")
print(example_df)
print("VA_IRR:")
print(example_df$VA_IRR)
print("DCA_IRR:")
print(example_df$DCA_IRR)

# ------------------------------------------------------------
# 5.1 Real ETF test (QQQ, DIA, SPY) 2013‑08 ~ 2023‑08
# ------------------------------------------------------------
tickers <- c("QQQ", "DIA", "SPY")
start_dt <- "2013-08-01"
end_dt   <- "2023-08-31"

lst <- list()
for (tk in tickers) {
  df  <- get_close_prices(tk, start_dt, end_dt)
  df  <- get_last_day_rows(df)
  df  <- add_VA(df)
  df  <- add_DCA(df)
  df  <- add_GA(df)
  lst[[tk]] <- df
  message("Processed: ", tk)
}

# helper to grab last row quickly
last_row <- function(d) d[nrow(d), ]

# Mean IRR & ROI across three ETFs
VA_IRR_mean   <- mean(sapply(lst, function(x) last_row(x)$VA_IRR),  na.rm = TRUE)
DCA_IRR_mean  <- mean(sapply(lst, function(x) last_row(x)$DCA_IRR), na.rm = TRUE)
GA_IRR_mean   <- mean(sapply(lst, function(x) last_row(x)$GA_IRR),  na.rm = TRUE)

VA_ROI_mean   <- mean(sapply(lst, function(x) last_row(x)$VA_ROI),  na.rm = TRUE)
DCA_ROI_mean  <- mean(sapply(lst, function(x) last_row(x)$DCA_ROI), na.rm = TRUE)
GA_ROI_mean   <- mean(sapply(lst, function(x) last_row(x)$GA_ROI),  na.rm = TRUE)

cat("\nMean IRR across ETFs:\n",
    "VA  :", VA_IRR_mean, "\n",
    "DCA :", DCA_IRR_mean, "\n",
    "GA  :", GA_IRR_mean, "\n")

cat("\nMean ROI across ETFs:\n",
    "VA  :", VA_ROI_mean, "\n",
    "DCA :", DCA_ROI_mean, "\n",
    "GA  :", GA_ROI_mean, "\n")

# Sharpe ratio means
risk_free <- 0
VA_sharpe_mean  <- mean(sapply(lst, function(x) (last_row(x)$VA_ROI - risk_free)  / sd(x$VA_ROI,  na.rm = TRUE)))
DCA_sharpe_mean <- mean(sapply(lst, function(x) (last_row(x)$DCA_ROI - risk_free) / sd(x$DCA_ROI, na.rm = TRUE)))
GA_sharpe_mean  <- mean(sapply(lst, function(x) (last_row(x)$GA_ROI - risk_free)  / sd(x$GA_ROI,  na.rm = TRUE)))

cat("\nMean Sharpe ratios:\n",
    "VA  :", VA_sharpe_mean, "\n",
    "DCA :", DCA_sharpe_mean, "\n",
    "GA  :", GA_sharpe_mean, "\n")

# ------------------------------------------------------------
# 5.2 Investment amount distribution visual (thresholds)
# ------------------------------------------------------------
thresholds <- c(200, 300, 400, 500)
count_over <- function(df, col) sapply(thresholds, function(x) sum(df[[col]] >= x, na.rm = TRUE))

VA_counts <- data.frame(
  Investment = thresholds,
  Count      = rowSums(sapply(lst, count_over, col = "VA_Period_Invest"))
)
GA_counts <- data.frame(
  Investment = thresholds,
  Count      = rowSums(sapply(lst, count_over, col = "GA_Period_Invest"))
)

VA_counts$Method <- "VA_Period_Invest"
GA_counts$Method <- "GA_Period_Invest"
combined_counts  <- rbind(VA_counts, GA_counts)

library(reshape2)
library(ggplot2)

ggplot(combined_counts,
       aes(x = Method, y = Count, fill = Method)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~Investment, ncol = 2, scales = "free_y") +
  geom_text(aes(label = Count),
            position = position_dodge(width = 0.9),
            vjust = 0.5, size = 5) +
  labs(title = "Investment Counts Above Thresholds",
       x = "Method", y = "Count") +
  theme_minimal() +
  theme(legend.position = "none")