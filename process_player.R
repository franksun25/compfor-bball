library(dplyr)
library(tidyr)

PTS <- 1
REB <- 1
AST <- 1
STL <- 1.5
BLK <- 1.5
TO <- -1
FGM <- 1
FGA <- -1
FTM <- 1
FTA <- -1
TPM <- 0

transform_player <- function(player) {
  player_temp <- player %>% 
    mutate(pts = points_scored,
           reb = offensive_rebounds + defensive_rebounds,
           ast = assists,
           stl = steals,
           blk = blocks,
           fgm = made_field_goals,
           fga = attempted_field_goals,
           ftm = made_free_throws,
           fta = attempted_free_throws,
           to = turnovers,
           date = date,
           tpm = made_three_point_field_goals,
           .keep = "none")
  return(player_temp)
}

fantasy_score <- function(player) {
  player_temp <- transform_player(player) %>%
    mutate(
      score = PTS * pts + REB * reb + AST * ast + STL * stl + BLK * blk + TO * to + FGM * fgm + FGA * fga + FTM * ftm + FTA * fta + TPM * tpm
    )
  return(player_temp)
}

category_score <- function(player) {
  player_temp <- transform_player(player) %>% 
    mutate(
      score = (pts - 16.9) / 6.6 + (tpm - 1.6) / 1.1 + (reb - 5.9) / 2.4 + (ast - 3.9) / 2.2 + (stl - 1.0) / 0.3 + (blk - 0.6) / 0.5 - (to - 1.9) / 0.8 + fga * (fgm / fga - 0.495) / 0.7 + fta * (ftm / fta - 0.8) / 0.37
    )
  return(player_temp)
}

fantasy_score_row <- function(player, category = FALSE) {
  if (category) {
    score_row <- category_score(player)
  }
  else {
    score_row <- fantasy_score(player)
  }
  player_temp <- score_row %>%
    # Select score and date columns
    select(score, date) %>%
    # mutate(
    #   score = cumsum(score)
    # ) %>% 
    # Pivot wider
    pivot_wider(names_from = date, values_from = score)
  return(player_temp)
}

