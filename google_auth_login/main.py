from urllib import response
import flask
from flask import Flask , render_template, jsonify
import requests
import json
from google.cloud import datastore
import random
import string
import os

# os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="/path/to/file.json"


app = Flask(__name__,
            static_url_path='', 
            static_folder='static',
            template_folder='templates')


CLIENT_ID = '701199836944-k9grqhb7tl30mm974iv62k6ge3ha2cqs.apps.googleusercontent.com'
CLIENT_SECRET = '' 
SCOPE='https%3A//www.googleapis.com/auth/userinfo.email'
REDIRECT_URI = 'http://127.0.0.1:5000/profile'

@app.route('/')
def welcome():
    # this is not needed and will be on front end. here is implemneted because this project did not have an GUI
    return render_template('welcome.html')


@app.route('/oauth')
def outhrequest():

    # if state is provided, it will be retrived and recorded by backend/DB to recognize the recognize the user
    # after google response

    url = f'https://accounts.google.com/o/oauth2/v2/auth?\
scope={SCOPE}&\
access_type=offline&\
prompt=consent&\
include_granted_scopes=true&\
response_type=code&\
redirect_uri={REDIRECT_URI}&\
client_id={CLIENT_ID}'

    # redirect to google:
    # alternatives:
    #   1- have this request in front end and send a seprate request two back end for backend tasks
    #   2- response with 'url' in json body


    return flask.redirect(url)


   

@app.route('/profile')
def oauth2callback():

    #  geeting auth code from google response 
    auth_code = flask.request.args.get('code')

    # generate data object to communicate with google API
    data = {'code': auth_code,
            'client_id': CLIENT_ID,
            'client_secret': CLIENT_SECRET,
            'redirect_uri': REDIRECT_URI,
            'grant_type': 'authorization_code'}

   
    r = requests.post('https://oauth2.googleapis.com/token', data=data)
    token=json.loads(r.text)

    # retrive jwt (TOKEN) + later: refresh token
    access_token=token['access_token']
    print("R1(token) is: ")
    print(token)

    # provide token in Authorization header for communicating with google API
    headers = {"Authorization": "Bearer "+access_token}

    # profile information
    r2=requests.get('https://people.googleapis.com/v1/people/me?personFields=names',headers=headers)
    information = json.loads(r2.text)
    print("R2 is: ")
    print(information)

    data={
        "First Name":information['names'][0]['givenName'],
        "Last Name":information['names'][0]['familyName'],
        "identifier":information['names'][0]['metadata']['source']['id'],

    }

    # email information 

    r3=requests.get('https://people.googleapis.com/v1/people/me?personFields=emailAddresses',headers=headers)

    information = json.loads(r3.text)
    print("R3 is: ")
    print(information)

    data['email']=information['emailAddresses'][0]['value']

    return jsonify(data)

    # ignore below line. same GUI reason as above
    # return render_template('results.html',result = data)
    
    
 

if __name__ == '__main__':
    app.run(debug=True)
