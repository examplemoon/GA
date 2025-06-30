# Entry point for the GA project -------------------------------------------
source("R/load_packages.R")
source("R/metrics.R")

# Parameters ---------------------------------------------------------------
tickers <- c("QQQ", "SPY")   # ✔️ 원하는 티커로 수정
years   <- 5                 # ✔️ 투자 기간(years window)
rf_rate <- 0.02              # ✔️ 무위험 수익률 (2%)

# Run analysis -------------------------------------------------------------
result <- calculate_metrics(
  tickers,
  years = years,
  risk_free_rate = rf_rate
)

print(head(result))
# 저장
write.csv(result, file = "data/processed/metrics_result.csv", row.names = FALSE)