import requests
import pyrebase
from secrets import firebaseConfig


def clear_data():
    db.child("stocktwits-trending").remove()
    print("data cleared from stocktwits-trending")

def add_data(data):
    db.child("stocktwits-trending").set(data)
    print("data added to realtime database")


firebase = pyrebase.initialize_app(firebaseConfig)
db = firebase.database()

response = requests.get('https://api.stocktwits.com/api/2/trending/symbols.json')

r_dict = response.json()['symbols']
clear_data()
add_data(r_dict)