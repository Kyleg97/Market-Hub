import requests
from bs4 import BeautifulSoup
import mysql.connector

class UpcomingIPO:
    def __init__(self, ticker, company, date, price_range, shares_num, volume):
        self.ticker = ticker
        self.company = company
        self.date = date
        self.price_range = price_range
        self.shares_num = shares_num
        self.volume = volume


def insert_to_table(upcoming_ipo_obj):
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')

        mySql_insert_query = """INSERT INTO upcoming_ipo (ticker_name, company_name, date, price_range, shares_num, volume) 
                               VALUES 
                               ("{}", "{}", "{}", "{}", "{}", "{}") """.format(upcoming_ipo_obj.ticker, upcoming_ipo_obj.company, upcoming_ipo_obj.date,
                                                                               upcoming_ipo_obj.price_range, upcoming_ipo_obj.shares_num, upcoming_ipo_obj.volume)

        cursor = connection.cursor()
        cursor.execute(mySql_insert_query)
        connection.commit()
        cursor.close()

    except mysql.connector.Error as error:
        print("Failed to insert record into upcoming_ipo table {}".format(error))

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
        cursor.execute("TRUNCATE TABLE {}".format('upcoming_ipo'))
        connection.commit()

    except mysql.connector.Error as error:
        print("Failed to clear data table {}".format(error))

    finally:
        if (connection.is_connected()):
            connection.close()


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
    ipo_list.append(UpcomingIPO(ticker, company, date, price_range, shares_num, volume))

if len(ipo_list) > 0:
    clear_table()
for obj in ipo_list:
    insert_to_table(obj)