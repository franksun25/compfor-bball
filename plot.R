library(ggplot2)


pivot_nba <- function(nba_data) {
  nba_data_long <- nba_data %>%
    pivot_longer(cols = -name, names_to = "date", values_to = "score") %>%
    mutate(date = as.Date(date)) %>%
    group_by(name) %>%
    mutate(cumscore = cumsum(score))
  
  return(nba_data_long)
}

plot_nba <- function(nba_data) {
  plot <- pivot_nba(nba_data) %>%
    ggplot(aes(x = date, y = cumscore, color = name, group = name)) +
    geom_line() +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(title = "NBA Fantasy Scores", x = "Date", y = "Cumulative Score")
  
  return(plot)
}