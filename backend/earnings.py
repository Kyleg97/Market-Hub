import datetime
from yahoo_earnings_calendar import YahooEarningsCalendar
import mysql.connector


class EarningInfo:
    def __init__(self, ticker, company_name, date_time, date_time_type, eps_estimate):
        self.ticker = ticker
        self.company_name = company_name
        self.date_time = date_time
        self.date_time_type = date_time_type
        self.eps_estimate = eps_estimate

        def __eq__(self, other):
            return self.ticker == other.ticker and self.company_name == other.company_name


def insert_to_table(ticker, volume, datetime, eps_estimate, company_name):
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')
        if ticker is None:
            ticker = "Error"
        if volume is None:
            volume = -1000
        if datetime is None:
            datetime = "Error"
        if eps_estimate is None:
            eps_estimate = -1000.0
        if company_name is None:
            company_name = "Error"
        mySql_insert_query = """INSERT INTO earnings_info (ticker_name, company_name, current_volume, earnings_datetime, eps_estimate) 
                               VALUES 
                               ("{}", "{}", "{}", "{}", "{}") """.format(ticker, company_name, volume, datetime, eps_estimate)

        cursor = connection.cursor()
        cursor.execute(mySql_insert_query)
        connection.commit()
        cursor.close()

    except mysql.connector.Error as error:
        print("Failed to insert record into common_tickers table {}".format(error))

    finally:
        if (connection.is_connected()):
            connection.close()


def clear_table():
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')
        cursor = connection.cursor()
        cursor.execute("TRUNCATE TABLE {}".format('earnings_info'))
        connection.commit()

    except mysql.connector.Error as error:
        print("Failed to clear data table {}".format(error))

    finally:
        if (connection.is_connected()):
            connection.close()

"""
date_from = datetime.datetime.strptime(
    'August 22 2020  10:00AM', '%B %d %Y %I:%M%p')
date_to = datetime.datetime.strptime(
    'September 10 2020  5:00PM', '%B %d %Y %I:%M%p')
"""


date_to = datetime.datetime.today().replace(year=datetime.datetime.today().year+1)

print("date_to: " + str(date_to))
print("today: " + str(datetime.datetime.today()))

yec = YahooEarningsCalendar()

earning_info_list = []

fetched_earnings = yec.earnings_between(datetime.datetime.today(), date_to)

for each in fetched_earnings:
    earning_info_list.append(EarningInfo(each['ticker'], each['companyshortname'], each['startdatetime'], each['startdatetimetype'], each['epsestimate']))

ticker_set = set()

for each in earning_info_list:
    ticker_set.add(each.ticker)

tickers_string = ""

for ticker in ticker_set:
    tickers_string += " " + ticker


clear_table()
for each in earning_info_list:
    date_time = datetime.datetime.strptime(each.date_time, '%Y-%m-%dT%H:%M:%S.%f%z')
    insert_to_table(each.ticker, -1000, date_time, each.eps_estimate, each.company_name)
