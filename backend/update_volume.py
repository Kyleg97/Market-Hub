import datetime
import math
import yfinance
import mysql.connector


def update_volume(ticker, volume, table_name):
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')
        if ticker is None:
            ticker = "Error"
        if volume is None:
            volume = -500

        mysql_update_query = """UPDATE {} SET current_volume="{}" WHERE ticker_name="{}" """.format(table_name, volume, ticker)

        cursor = connection.cursor()

        cursor.execute(mysql_update_query)
        connection.commit()

        mysql_sort_query = """ALTER TABLE {} ORDER BY current_volume DESC""".format(table_name)
        cursor.execute(mysql_sort_query)
        connection.commit()

        cursor.close()

    except mysql.connector.Error as error:
        print("Failed to update record in the table {}".format(error))

    finally:
        if (connection.is_connected()):
            connection.close()


def read_from_table(table_name):
    ticker_list = []
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')

        cursor = connection.cursor()

        cursor.execute('SELECT * FROM praw_schema.{}'.format(table_name))

        for row in cursor.fetchall():
            if table_name == "earnings_info":
                ticker_list.append(row[0])
            elif table_name == "robinhood_popular":
                ticker_list.append(row[1])
        cursor.close()

    except mysql.connector.Error as error:
        print("Failed to read table. {}".format(error))

    finally:
        if (connection.is_connected()):
            connection.close()

    return ticker_list


def get_ticker_info(table_name):
    ticker_list = read_from_table(table_name)
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
            volume_dict[ticker] = data['Volume'][ticker][str(today)]

    for each in volume_dict:
        update_volume(each, volume_dict[each], table_name)
    print("Finished updating: " + table_name + ".")


get_ticker_info("earnings_info")
get_ticker_info("robinhood_popular")
