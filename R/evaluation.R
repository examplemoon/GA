plot_result <- function(price_data) {
  ggplot(price_data, aes(x = index(price_data))) +
    geom_line(aes(y = Cl(price_data))) +
    labs(title = "종가 추이", x = "날짜", y = "가격")
}