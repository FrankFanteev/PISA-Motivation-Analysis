from flask import Flask, request, render_template, make_response, url_for, redirect
from dotenv import load_dotenv
import mysql.connector
import json
import os

app = Flask(__name__, template_folder = 'templates', static_folder='static')
load_dotenv('./.env')


#connect using python mysql connector
cnx = mysql.connector.connect(
    user = os.environ['MYSQL_USERNAME'],
    password = os.environ['MYSQL_PASSWORD'],
    host = os.environ['MYSQL_HOST'],
    database = os.environ['MYSQL_DB']
)

@app.route('/')
def home():
    cursor = cnx.cursor()
    cursor.execute('SELECT id, CNT,SCHOOLID FROM student LIMIT 20')
    #sql returns list of tuples of selected variables
    rows = cursor.fetchall()
    #transfer tuples into dictionaries
    countries  = [dict(zip(cursor.column_names, student)) for student in rows]
    
    cursor.close()
    return render_template('home.html', countries = countries)

@app.route('/<string:page_name>/')
def render_static(page_name):
    return render_template('%s.html' % page_name)

@app.route('/country/<country_stats>')
def get_stats(country_stats):
    cursor = cnx.cursor()
    query = ('SELECT * FROM school WHERE CNT = %(cnt)s')
    cursor.execute(query, { 'cnt': country_stats})

    country = cursor.fetchone()

    country_dict = dict(zip(cursor.column_names, country))
    cursor.close()
    return render_template('country.html', name = country_dict['CNT'])



if __name__ == '__main__':
    port = os.environ.get('FLASK_PORT') or 5000
    app.run(port=port)

















