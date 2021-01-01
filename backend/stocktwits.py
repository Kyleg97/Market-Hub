import requests
import pyrebase
from secrets import firebaseConfig, EMAIL, PW


def clear_data():
    db.child("stocktwits-trending").remove(user['idToken'])
    print("data cleared from stocktwits-trending")

def add_data(data):
    db.child("stocktwits-trending").set(data, user['idToken'])
    print("data added to realtime database")


firebase = pyrebase.initialize_app(firebaseConfig)

auth = firebase.auth()
db = firebase.database()

user = auth.sign_in_with_email_and_password(EMAIL, PW)

response = requests.get('https://api.stocktwits.com/api/2/trending/symbols.json')

r_dict = response.json()['symbols']
clear_data()
add_data(r_dict)