#Stephen Bowen 2021

# System modules
from __future__ import print_function
import os
import time
import requests
import logging

# Server modules
import flask
from flask import Flask

# Custom modules
from estop import EstopNoGui
from API import SpotAPI

# Set the web app name and create the app object
app = Flask("SpotAPI")

# Log user into spot and create instance of API
@app.route('/start')
def start():
    print("Starting")
    global activeAPI
    try:
        activeAPI = SpotAPI(flask.request.args.get("user"), flask.request.args.get("pass"))
        return flask.jsonify("Success!")
    except:
        return flask.jsonify("Failure")

# Receive generic request and execute the command
@app.route('/GenericRequest')
def GenericRequest():
    global activeAPI
    try:
        activeAPI.GenericRequest(flask.request.args.get("request"))
        return flask.jsonify("Success!")
    except:
        return flask.jsonify("Failure")

# Trigger EStop
@app.route('/stop')
def stop():
    global activeAPI
    try:
        activeAPI.stop()
        return flask.jsonify("Success!")
    except:
        return flask.jsonify("Failure")

# Clear EStop
@app.route('/ClearStop')
def clearStop():
    global activeAPI
    try:
        activeAPI.ClearStop()
        return flask.jsonify("Success!")
    except:
        return flask.jsonify("Failure")

# End connection to robot and set activeAPI to NULL
@app.route('/End')
def End():
    global activeAPI
    try:
        activeAPI.End()
        activeAPI = None
        return flask.jsonify("Success!")
    except:
        return flask.jsonify("Failure")

# Run web app on local machine
if __name__ == '__main__':
    app.run(host="192.168.80.100", port=8080)