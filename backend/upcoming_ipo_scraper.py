import requests
from bs4 import BeautifulSoup
import mysql.connector
import pyrebase
from secrets import firebaseConfig

class UpcomingIPO:
    def __init__(self, ticker, company, date, price_range, shares_num, volume):
        self.ticker = ticker
        self.company = company
        self.date = date
        self.price_range = price_range
        self.shares_num = shares_num
        self.volume = volume


def clear_data():
    db.child("ipo-info").remove()
    print("data cleared from ipo-info")

def add_data(data):
    db.child("ipo-info").set(data)
    print("data added to realtime database")


firebase = pyrebase.initialize_app(firebaseConfig)
db = firebase.database()

URL = "https://www.marketbeat.com/ipos/"
page = requests.get(URL)

soup = BeautifulSoup(page.content, 'html.parser')

ipo_list = []

table_body = soup.find('tbody')

rows = table_body.find_all('tr')
for row in rows:
    cols = row.find_all('td')
    ticker = cols[0].find("strong").text
    company = cols[0].text[len(ticker): len(cols[0].text)]
    date = cols[1].text
    price_range = cols[2].text
    shares_num = cols[3].text
    volume = cols[4].text.replace('$', '')
    #ipo_list.append(UpcomingIPO(ticker, company, date, price_range, shares_num, volume))
    ipo_list.append({
        'ticker': ticker,
        'company': company,
        'date': date,
        'price_range': price_range,
        'shares_num': shares_num,
        'volume': volume
    })

clear_data()
add_data(ipo_list)