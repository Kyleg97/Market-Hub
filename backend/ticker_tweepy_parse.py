import datetime
import csv
import tweepy
from keys import API_KEY, API_SECRET, ACCESS_TOKEN, ACCESS_SECRET


def search_twitter(ticker):
    query = "$" + ticker
    tweets = tweepy.Cursor(api.search, q=query, since=yesterday.date(), until=today.date(), lang='en',
                           result_type='popular').items()
    return len(list(tweets))

with open('stocklist.csv', mode='r') as infile:
    reader = csv.reader(infile)
    ticker_dict = {rows[0]: rows[1] for rows in reader}

auth = tweepy.OAuthHandler(consumer_key=API_KEY, consumer_secret=API_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_SECRET)

api = tweepy.API(auth)

today = datetime.datetime.today()
yesterday = today - datetime.timedelta(days=2)

mentions = {}

tweets = tweepy.Cursor(api.search, q="#stocks", since=yesterday.date(), until=today.date(), lang='en',
                       result_type='popular').items()

tweets2 = tweepy.Cursor(api.search, q="#stockmarket", since=yesterday.date(), until=today.date(), lang='en',
                       result_type='popular').items()

for tweet in tweets:
    print(tweet.text)

for tweet in tweets2:
    print(tweet.text)

#for ticker in ticker_dict.items():
    #print(ticker[0])
    #mentions[ticker[0]] = search_twitter(ticker[0])
    #print(mentions)
