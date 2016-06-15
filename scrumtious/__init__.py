""" scrumtious/__init__.py
"""
from flask import Flask
from flask_pymongo import PyMongo
from flask_redis import FlaskRedis
from flask_socketio import SocketIO

# Set up app
app = Flask(__name__)
app.config.from_pyfile('config.py')
mongo = PyMongo(app)
redis = FlaskRedis(app)
socketio = SocketIO(app)

# Set up routes, socket
import scrumtious.routes, scrumtious.socket
