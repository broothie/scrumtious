# src/server/server.coffee becomes:
### server.js ###
express = require 'express'

# Connect to database
require('mongodb').MongoClient.connect process.env.MONGODB_URI, (err, db) ->
  if err
    console.log err
    process.exit 1
  exports.db = db
  console.log 'Database connection ready'

  # Connect to redis
  exports.redis = require('redis').createClient process.env.REDISCLOUD_URL
  exports.records = require './models/RecordManager'

  # Create Express object
  app = express()
  # Set up static dir
  app.use express.static require('path').join __dirname, 'public'

  # Set up bodyparser for handling forms
  bodyparser = require 'body-parser'
  app.use bodyparser.json()
  app.use bodyparser.urlencoded {extended: true}

  # Set up routes
  app.use '/', require './routes'

  # Start server
  app.set 'port', process.env.PORT
  exports.server = server = app.listen app.get 'port'
  console.log 'Server running'

  # Set up socket.io
  exports.socketio = require('socket.io')(server)
