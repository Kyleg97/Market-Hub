import requests
from bs4 import BeautifulSoup
import mysql.connector

class PopularStock:
    def __init__(self, company_name, ticker, price, market_cap):
        self.company_name = company_name
        self.ticker = ticker
        self.price = price
        self.market_cap = market_cap


def insert_to_table(company_name, ticker, price, market_cap):
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')
        if ticker is None:
            ticker = "Error"
        if company_name is None:
            company_name = "Error"
        if price is None:
            price = "Error"
        if market_cap is None:
            market_cap = "Error"

        mySql_insert_query = """INSERT INTO robinhood_popular (company_name, ticker_name, current_price, market_cap, current_volume) 
                               VALUES 
                               ("{}", "{}", "{}", "{}", {}) """.format(company_name, ticker, price, market_cap, -1000)

        cursor = connection.cursor()
        cursor.execute(mySql_insert_query)
        connection.commit()
        cursor.close()

    except mysql.connector.Error as error:
        print("Failed to insert record into robinhood_popular table {}".format(error))

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
        cursor.execute("TRUNCATE TABLE {}".format('robinhood_popular'))
        connection.commit()

    except mysql.connector.Error as error:
        print("Failed to clear data table {}".format(error))

    finally:
        if (connection.is_connected()):
            connection.close()

URL = "https://robinhood.com/collections/100-most-popular"
page = requests.get(URL)

soup = BeautifulSoup(page.content, 'html.parser')

results = soup.find(id='react_root')

#print(results.prettify())

company_names = results.find_all('span', class_='_2fMBL180hIqVoxOuNVJgST')
td_row_1 = results.find_all('td', class_='_6M0lojguuu-oGcosChSe6')

popular = []

for each in td_row_1:
    ticker = each.find_next_sibling("td").text
    price = each.find_next_sibling("td").find_next_sibling("td").text
    percent_change_today = each.find_next_sibling("td").find_next_sibling("td").find_next_sibling("td").text
    market_cap = each.find_next_sibling("td").find_next_sibling("td").find_next_sibling("td").find_next_sibling("td").text
    #print("market cap: " + market_cap)
    #print(each.text + " : " + ticker + " : " + price + " : " + percent_change_today)
    popular.append(PopularStock(each.text, ticker, price, market_cap))

clear_table()
for each in popular:
    print(each.company_name + "(" + each.ticker + "): " + each.price)
    insert_to_table(each.company_name, each.ticker, each.price, each.market_cap)

