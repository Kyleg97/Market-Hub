import datetime
import math
import yfinance
import mysql.connector
import pyrebase
from secrets import firebaseConfig, EMAIL, PW


def get_ticker_list():
    ticker_list = []
    robinhood_popular = db.child("robinhood-popular").get()
    for data in robinhood_popular.each():
        ticker_list.append(data.val()['ticker'])
    earnings_info = db.child("earnings-info").get()
    for data in earnings_info.each():
        ticker_list.append(data.val()['ticker'])
    return ticker_list


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

    for ticker in ticker_list:
        if not math.isnan(data['Volume'][ticker][str(today)]):
            volume_dict[ticker] = str(data['Volume'][ticker][str(today)])
    
    return volume_dict


def update_robinhood_data(data):
    for each in data:
        db.child("robinhood-popular").child(each).update(data[each], user['idToken'])

def update_earnings_data(data):
    for each in data:
        db.child("earnings-info").child(each).update(data[each], user['idToken'])
    

firebase = pyrebase.initialize_app(firebaseConfig)

auth = firebase.auth()
db = firebase.database()

user = auth.sign_in_with_email_and_password(EMAIL, PW)

robinhood_dict = db.child("robinhood-popular").get().val()

earnings_dict = db.child("earnings-info").get().val()

volume_info = get_volume_info(get_ticker_list())
for each in volume_info:
    if each in robinhood_dict:
        robinhood_dict[each]['volume'] = volume_info[each]
    if each in earnings_dict:
        earnings_dict[each]['volume'] = volume_info[each]

update_robinhood_data(robinhood_dict)
update_earnings_data(earnings_dict)