import praw
import re
import csv
import datetime
from datetime import datetime
import random
from praw.models import MoreComments
from operator import itemgetter
import mysql.connector
from collections import Counter
from keys import CLIENT_ID, CLIENT_SECRET


def insert_to_table(table_name, ticker, count):
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')
        mySql_insert_query = """INSERT INTO {} (ticker_name, mention_count) 
                               VALUES 
                               ('{}', {}) """.format(table_name, ticker, count)

        cursor = connection.cursor()
        cursor.execute(mySql_insert_query)
        connection.commit()
        cursor.close()

    except mysql.connector.Error as error:
        print("Failed to insert record into common_tickers table {}".format(error))

    finally:
        if (connection.is_connected()):
            connection.close()


def insert_to_new_table(ticker, total_count, company_name, investing, options, pennystocks, smallstreetbets, stocks, thewallstreet, wallstreetbets):
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')
        if ticker is None:
            ticker = 0
        if total_count is None:
            total_count = 0
        if investing is None:
            investing = 0
        if options is None:
            options = 0
        if pennystocks is None:
            pennystocks = 0
        if smallstreetbets is None:
            smallstreetbets = 0
        if stocks is None:
            stocks = 0
        if thewallstreet is None:
            thewallstreet = 0
        if wallstreetbets is None:
            wallstreetbets = 0
        if company_name is None:
            company_name = "DATABASE_ERROR"

        mySql_insert_query = """INSERT INTO common_tickers (ticker_name, total_mention_count, investing, options, 
                                pennystocks, smallstreetbets, stocks, thewallstreet, wallstreetbets, company_name) 
                               VALUES 
                               ('{}', {}, {}, {}, {}, {}, {}, {}, {}, '{}') """.format(ticker, total_count, investing, options, pennystocks, smallstreetbets, stocks, thewallstreet, wallstreetbets, company_name)

        cursor = connection.cursor()
        cursor.execute(mySql_insert_query)
        connection.commit()
        cursor.close()

    except mysql.connector.Error as error:
        print("Failed to insert record into common_tickers table {}".format(error))

    finally:
        if connection.is_connected():
            connection.close()


def clear_table(table_name):
    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='praw_schema',
                                             user='root',
                                             password='password')
        cursor = connection.cursor()
        cursor.execute("TRUNCATE TABLE {}".format(table_name))
        connection.commit()

    except mysql.connector.Error as error:
        print("Failed to clear data table {}".format(error))

    finally:
        if (connection.is_connected()):
            connection.close()

def subreddit_parse(subreddit_name, table_name):
    from collections import Counter

    reddit = praw.Reddit(client_id=CLIENT_ID, client_secret=CLIENT_SECRET,
                         user_agent='WSB Parser')

    posts_today_list = []
    sub = reddit.subreddit(subreddit_name)
    for submission in sub.new(limit=100):
        if not submission.stickied:
            submission_date = datetime.utcfromtimestamp(submission.created)
            submission_delta = str(submission_date - datetime.utcnow())

            if 'day' not in submission_delta:
                posts_today_list.append(submission)

    word_list = []
    for post in posts_today_list:
        for word in post.title.split():
            word_list.append(re.sub('[^A-Za-z0-9]+', '', word.upper()))
        post.comments.replace_more()
        if not post.stickied:
            for word in post.selftext.split():
                word_list.append(re.sub('[^A-Za-z0-9]+', '', word.upper()))
        for comment in post.comments:
            if isinstance(comment, MoreComments):
                continue
            for word in comment.body.split():
                word_list.append(re.sub('[^A-Za-z0-9]+', '', word.upper()))

    counter = Counter(word_list)
    most_occurring = counter.most_common(len(word_list))

    test = set(word_list).intersection(ticker_dict)

    new_dict = {}

    for ticker in test:
        for occurring in most_occurring:
            if ticker.upper() == occurring[0].upper() and ticker.upper() not in ignore:
                new_dict[ticker] = occurring[1]
            if ticker.upper() == "TECH":
                for each in tech:
                    if each in most_occurring:
                        new_dict[each] += 1
    """
    clear_table(table_name)
    for key, value in sorted(new_dict.items(), key=itemgetter(1), reverse=True):
        insert_to_table(table_name, key, value)
    """
    return new_dict

def random_ticker():
    ticker = random.sample(list(ticker_dict), 1)[0]
    name = ticker_dict[ticker]
    return ticker, name


with open('stocklist.csv', mode='r') as infile:
    reader = csv.reader(infile)
    ticker_dict = {rows[0]: rows[1] for rows in reader}

ignore = ["I", "ATH", "DD", "A", "ONCE", "TICKER", "ALL", "LOAN", "EDIT", "HE", "IT", "TOO", "WOW", "DO", "FOR", "ON",
          "ARE", "AT", "BE", "SO", "OR", "AN", "GOOD", "OUT", "NOW", "HAS", "GO", "BY", "ANY", "WELL", "AM", "PM", "ONE",
          "CASH", "SEE", "NEW", "VERY", "BIG", "NEXT", "TWO", "POST", "REAL", "BEST", "COST", "RUN", "PLAY", "IMO",
          "NEW", "VERY", "BIG", "NEXT", "TWO", "POST", "REAL", "BEST", "COST", "RUN", "PLAY", "IMO",
          "PER", "LOW", "BIT", "ELSE", "EVER", "BEAT", "GROW", "HOME", "JOB", "STAY", "GAIN", "HI", "HOPE", "NICE",
          "PLAN", "FUND", "LIFE", "PUMP", "OLD", "JOBS", "WINS", "MAIN", "MIND", "TYPE", "GLAD", "MAN", "LOVE", "TELL",
          "CARE", "THO", "EOD", "LIVE", "HES", "EAT", "TECH"]
tech = ['TSLA', 'AAPL', 'MSFT', 'GOOG', 'GOOGL', 'FB', 'AMD', 'NFLX', 'SE', 'BABA', 'NVDA', 'ADBE', 'AMZN',
         'INTC', 'ORCL', 'QCOM', 'SHOP', 'IBM', 'ZM', 'WORK', 'ATVI', 'ADSK', 'SPOT', 'EBAY', 'TWLO', 'NET', ]
subreddits = {"stocks": "stocks_sr", "pennystocks": "pennystocks_sr", "wallstreetbets": "wallstreetbets_sr",
              "smallstreetbets": "smallstreetbets_sr", "investing": "investing_sr", "thewallstreet": "thewallstreet_sr",
              "options": "options_sr"}

print("ticker dict: " + str(ticker_dict['SE']))

stock_dict = {}
pennystocks_dict = {}
wsb_dict = {}
ssb_dict = {}
investing_dict = {}
thewallstreet_dict = {}
options_dict = {}

for each in subreddits:
    print("Parsing " + each + "...")
    if each == "stocks":
        stock_dict = subreddit_parse(each, subreddits[each])
        print(stock_dict)
    if each == "pennystocks":
        pennystocks_dict = subreddit_parse(each, subreddits[each])
        print(pennystocks_dict)
    if each == "wallstreetbets":
        wsb_dict = subreddit_parse(each, subreddits[each])
        print(wsb_dict)
    if each == "smallstreetbets":
        ssb_dict = subreddit_parse(each, subreddits[each])
        print(ssb_dict)
    if each == "investing":
        investing_dict = subreddit_parse(each, subreddits[each])
        print(investing_dict)
    if each == "thewallstreet":
        thewallstreet_dict = subreddit_parse(each, subreddits[each])
        print(thewallstreet_dict)
    if each == "options":
        options_dict = subreddit_parse(each, subreddits[each])
        print(options_dict)

clear_table("common_tickers")

common_tickers = dict(Counter(stock_dict) + Counter(pennystocks_dict) + Counter(wsb_dict) + Counter(ssb_dict) +
                      Counter(investing_dict) + Counter(thewallstreet_dict) + Counter(options_dict))

print(common_tickers)

for key, value in sorted(common_tickers.items(), key=itemgetter(1), reverse=True):
    print("ticker_dict.get(key): " + str(ticker_dict.get(key)))
    insert_to_new_table(key, value, str(ticker_dict.get(key)), investing_dict.get(key), options_dict.get(key),
                        pennystocks_dict.get(key), ssb_dict.get(key), stock_dict.get(key),
                        thewallstreet_dict.get(key), wsb_dict.get(key))
