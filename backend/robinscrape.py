import requests
from bs4 import BeautifulSoup
import pyrebase
from secrets import firebaseConfig

def clear_data():
    db.child("robinhood-popular").remove()
    print("data cleared")

def add_data(data):
    db.child("robinhood-popular").set(data)
    print("data added to realtime database")

firebase = pyrebase.initialize_app(firebaseConfig)
db = firebase.database()

URL = "https://robinhood.com/collections/100-most-popular"
page = requests.get(URL)

soup = BeautifulSoup(page.content, 'html.parser')

results = soup.find(id='react_root')

company_names = results.find_all('span', class_='_2fMBL180hIqVoxOuNVJgST')
td_row_1 = results.find_all('td', class_='_6M0lojguuu-oGcosChSe6')

popular = {}

for each in td_row_1:
    ticker = each.find_next_sibling("td").text
    price = each.find_next_sibling("td").find_next_sibling("td").text
    percent_change_today = each.find_next_sibling("td").find_next_sibling("td").find_next_sibling("td").text
    market_cap = each.find_next_sibling("td").find_next_sibling("td").find_next_sibling("td").find_next_sibling("td").text
    popular[ticker] = {
        "company": each.text,
        "price": price,
        "market_cap": market_cap,
        "volume": -1000 
    }

clear_data()
add_data(popular)

