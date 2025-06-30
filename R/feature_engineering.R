calculate_indicators <- function(price_data) {
  price_data$SMA20 <- SMA(Cl(price_data), n = 20)
  price_data$SMA50 <- SMA(Cl(price_data), n = 50)
  return(price_data)
}