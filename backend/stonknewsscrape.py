import requests
from bs4 import BeautifulSoup
import pyrebase
import yfinance
import datetime
import math
from secrets import firebaseConfig, EMAIL, PW

def clear_data():
    db.child("robinhood-popular").remove(user['idToken'])
    print("data cleared")

def add_data(data):
    db.child("robinhood-popular").set(data, user['idToken'])
    print("data added to realtime database")

def get_volume_info(ticker_list):
    ticker_string = ""

    for each in ticker_list:
        ticker_string += each
        ticker_string += " "

    data = yfinance.download(ticker_string, period="5d", threads=True)

    today = datetime.date.today()
    if today.isoweekday() == 6:
        today = today - datetime.timedelta(days=1)
    elif today.isoweekday() == 7:
        today = today - datetime.timedelta(days=2)

    volume_dict = {}

    #for (columnName, columnData) in data.iteritems():
        #print('Column Name : ', columnName)
        #print('Column Contents : ', columnData.values)

    for ticker in ticker_list:
        if not math.isnan(data['Volume'][ticker][str(today)]):
            volume_dict[ticker] = {}
            volume_dict[ticker]['volume'] = str(data['Volume'][ticker][str(today)])
            volume_dict[ticker]['open'] = str(data['Open'][ticker][str(today)])
            volume_dict[ticker]['low'] = str(data['Low'][ticker][str(today)])
            volume_dict[ticker]['high'] = str(data['High'][ticker][str(today)])
            #volume_dict[ticker]['close'] = str(data['Close'][ticker][str(today)])
    
    return volume_dict


firebase = pyrebase.initialize_app(firebaseConfig)

auth = firebase.auth()
db = firebase.database()

user = auth.sign_in_with_email_and_password(EMAIL, PW)

URL = "https://stonks.news/top-100/robinhood"
page = requests.get(URL)

soup = BeautifulSoup(page.content, 'html.parser')

table = soup.find("table")

trs = table.find_all('tr')

popular = []

for tr in trs:
    cols = tr.find_all('td')
    cols = [x.text.strip() for x in cols]
    print(cols)
    if cols:
        ticker = str(cols[1])
        company = str(cols[2])
        market_cap = str(cols[3])
        popular.append({
            "ticker": ticker,
            "company": company,
            "open": -1000,
            "low": -1000,
            "high": -1000,
            "market_cap": market_cap,
            "volume": -1000
        })

ticker_list = []
for each in popular:
    ticker_list.append(each['ticker'])

volume_data = get_volume_info(ticker_list)

for each in popular:
    each['volume'] = volume_data[each['ticker']]['volume']
    each['open'] = volume_data[each['ticker']]['open']
    each['low'] = volume_data[each['ticker']]['low']
    each['high'] = volume_data[each['ticker']]['high']

clear_data()
add_data(popular)

