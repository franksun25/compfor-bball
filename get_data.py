from basketball_reference_web_scraper import client
from basketball_reference_web_scraper.data import OutputType
from basketball_reference_web_scraper.data import Team
from basketball_reference_web_scraper.data import Position
from basketball_reference_web_scraper.data import OutputWriteOption

import os
import time

import requests
from bs4 import BeautifulSoup

output = OutputType.CSV
output_write_option = OutputWriteOption.WRITE

teams = ["ATL", "BOS", "BRK", "CHI", "CHO", "CLE", "DAL", "DEN", "DET", "GSW", "HOU", "IND", "LAC", "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", "OKC", "ORL", "PHI", "PHO", "POR", "SAC", "SAS", "TOR", "UTA", "WAS"]

# Get the team's roster usernames on bball reference
def get_roster(team):
    r = requests.get(f"https://www.basketball-reference.com/teams/{team}/2023.html")

    soup = BeautifulSoup(r.content, "html.parser")
    table = soup.find("table", id="roster")
    rows = table.find_all("tr")

    roster = []
    # In each row, find the data-append-csv attribute in the td class
    for row in rows:
        cell = row.find("td", {"data-stat": "player"})
        if cell:
            roster.append(cell["data-append-csv"]) 

    return roster


# Load player data from rosters into csv
def csv_roster(team):
    os.makedirs(f"player_data/{team}", exist_ok=True)
    roster = get_roster(team)
    for player in roster:
        print(f"Getting data for {player}")
        client.regular_season_player_box_scores(
            player_identifier=player,
            season_end_year=2023,
            output_type=output,
            output_write_option=output_write_option,
            output_file_path=f"player_data/{team}/{player}.csv"
        )
        time.sleep(3)

if __name__ == "__main__":
    for team in teams:
        print(f"Getting data for {team}")
        csv_roster(team)
        time.sleep(3)
