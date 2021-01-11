from datetime import datetime
from dateutil.relativedelta import relativedelta
from yahoo_earnings_calendar import YahooEarningsCalendar
import mysql.connector
from dateutil import parser
import pyrebase
from secrets import firebaseConfig, EMAIL, PW


class EarningInfo:
    def __init__(self, ticker, company_name, date_time, date_time_type, eps_estimate):
        self.ticker = ticker
        self.company_name = company_name
        self.date_time = date_time
        self.date_time_type = date_time_type
        self.eps_estimate = eps_estimate


def clear_data():
    db.child("earnings-info").remove(user['idToken'])
    print("data cleared")

def add_data(data):
    db.child("earnings-info").set(data, user['idToken'])
    print("data added to realtime database")


firebase = pyrebase.initialize_app(firebaseConfig)

auth = firebase.auth()
db = firebase.database()

user = auth.sign_in_with_email_and_password(EMAIL, PW)

today = datetime.today()
#date_to = today + relativedelta(years=1)
date_to = today + relativedelta(months=1)

yec = YahooEarningsCalendar()

earning_info_list = []
print("retrieving earning info...")
fetched_earnings = yec.earnings_between(today, date_to)

print("fetched earnings...")
print(fetched_earnings)

#for each in fetched_earnings:
#    earning_info_list.append(EarningInfo(each['ticker'], each['companyshortname'], each['startdatetime'], each['startdatetimetype'], each['epsestimate']))

#ticker_set = set()

#for each in earning_info_list:
#    ticker_set.add(each.ticker)

#tickers_string = ""

#for ticker in ticker_set:
#    tickers_string += " " + ticker

#data = {}
#data = []

# for each in earning_info_list:
#     date_time = datetime.strptime(each.date_time, '%Y-%m-%dT%H:%M:%S.%fZ')
#     if each.eps_estimate is None:
#         each.eps_estimate = "-1000"
#     data.append({
#         "ticker": each.ticker,
#         "company": each.company_name,
#         "datetime": str(date_time),
#         "eps_estimate": each.eps_estimate,
#         "volume": -1000
#     })

#print(data)
clear_data()
add_data(fetched_earnings)