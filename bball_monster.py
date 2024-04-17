import requests
from bs4 import BeautifulSoup
import csv

starting_season = 130 # 2022-23 season
num_seasons = 1

def scrape_year(year):
    r = requests.get(f"http://history.basketballmonster.com/Season?seasonId={year}&per=g")
    soup = BeautifulSoup(r.content, "html.parser")
    table = soup.find("table", class_="seasonDetailsT")
    rows = table.find_all("tr", attrs={"onmouseover": "this.className = 'hlt';"})
    for row in rows:
        name = row.find("td", class_="boldLeft playerCell")
        name = name.find("a").text
        # Write this row to a csv file
        cells = row.find_all("td")
        with open(f"bball_monster_data/{year}.csv", "a") as f:
            writer = csv.writer(f)
            writer.writerow([name] + [cell.text for cell in cells])
        

if __name__ == "__main__":
    for year in range(starting_season, starting_season + num_seasons):
        scrape_year(year)
