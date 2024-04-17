source("read_names.R")
source("process_player.R")
library(zoo)

TEAMS <- c(
  "ATL", "BOS", "BRK", "CHI", "CHO", "CLE",
  "DAL", "DEN", "DET", "GSW", "HOU", "IND", "LAC", "LAL",
  "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", "OKC", "ORL",
  "PHI", "PHO", "POR", "SAC", "SAS", "TOR", "UTA", "WAS"
)

team_data <- function(team, category = FALSE) {
  files <- file_names(paste("player_data/", team, sep = ""))
  for (file in files) {
    data <- single_player_data(team, file)
    data <- fantasy_score_row(data, category)
    data$name <- strip_csv(file)
    if (exists("team_data_")) {
      team_data_ <- bind_rows(team_data_, data)
    } else {
      team_data_ <- data
    }
  }
  return(team_data_)
}

all_teams_data <- function(category = FALSE) {
  for (team in TEAMS) {
    data <- team_data(team, category)
    if (exists("all_teams_data_")) {
      all_teams_data_ <- bind_rows(all_teams_data_, data)
    } else {
      all_teams_data_ <- data
    }
  }
  all_teams_data_ <- all_teams_data_ %>% 
    replace(is.na(.), 0)
  aggregate(all_teams_data_, by = list(name = all_teams_data_$name), min, na.rm = FALSE)
  all_teams_data_ <- all_teams_data_ %>%
    select(sort(names(.))) %>%
    distinct(name, .keep_all = TRUE)

  all_teams_data_ <- t(all_teams_data_) %>%
    apply(MARGIN = 2, FUN = na.locf, na.rm = FALSE)
  return(as.data.frame(t(all_teams_data_)))
}

player_games_played <- function(team) {
  files <- file_names(paste("player_data/", team, sep = ""))
  for (file in files) {
    data <- single_player_data(team, file)
    games_played <- dim(data)[1]
    after_all_star <- dim(data %>% filter(date >= "2023-02-19"))[1]
    name <- strip_csv(file)
    final_row <- data.frame(name = name, games_played = games_played, after_all_star = after_all_star)
    if (exists("team_data_")) {
      team_data_ <- bind_rows(team_data_, final_row)
    } else {
      team_data_ <- final_row
    }
  }
  return(team_data_)
}

all_games_player <- function() {
  for (team in TEAMS) {
    data <- player_games_played(team)
    if (exists("all_teams_data_")) {
      all_teams_data_ <- bind_rows(all_teams_data_, data)
    } else {
      all_teams_data_ <- data
    }
  }
  return(all_teams_data_ %>% 
           distinct(name, .keep_all = TRUE))
}