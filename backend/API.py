from flask import Flask, jsonify
from flaskext.mysql import MySQL

app = Flask(__name__)
mysql = MySQL()

app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'password'
app.config['MYSQL_DATABASE_DB'] = 'praw_schema'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'

mysql.init_app(app)

@app.route('/common_tickers')
def get_common_tickers():
    cursor = mysql.connect().cursor()
    cursor.execute('''SELECT * FROM praw_schema.common_tickers''')
    r = [dict((cursor.description[i][0], value)
              for i, value in enumerate(row)) for row in cursor.fetchall()]
    return jsonify({'CommonTickers': r})

@app.route('/earnings_info')
def get_earnings_info():
    cursor = mysql.connect().cursor()
    cursor.execute('''SELECT * FROM praw_schema.earnings_info''')
    r = [dict((cursor.description[i][0], value)
              for i, value in enumerate(row)) for row in cursor.fetchall()]
    return jsonify({'EarningsInfo': r})