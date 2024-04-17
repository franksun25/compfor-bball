file_names <- function(dir) {
  files <- list.files(path=dir, pattern="*.csv", full.names=FALSE, recursive=FALSE);
  return (files);
}

single_player_data <- function(team, filename) {
  data <- read.csv(paste("player_data/", team, "/", filename, sep = ""))
  return(data)
}

strip_csv <- function(filename) {
  return(sub(".csv", "", filename))
}