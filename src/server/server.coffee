# src/server/server.coffee becomes:
### src/server.js ###
express = require 'express'

# Connect to database
require('mongodb').MongoClient.connect process.env.MONGODB_URI or 'mongodb://localhost:27017/scrumtious', (err, database) ->
  if err
    console.log err
    process.exit 1

  exports.db = database
  console.log 'Database connection ready'

  # Create Express object
  app = express()
  # Set up static dir
  app.use express.static require('path').join __dirname, 'public'

  # Set up session and cookies
  app.use require('express-session') {
    secret: require('node-uuid').v4()
    resave: true
    saveUninitialized: true
  }
  app.use require('cookie-parser')()

  # Set up bodyparser for handling forms
  # TODO Use CSRF for secure form posting
  bodyparser = require 'body-parser'
  app.use bodyparser.json()
  app.use bodyparser.urlencoded {extended: true}

  # Set up routes
  app.use '/', require './routes'

  # Start server
  app.set 'port', process.env.PORT or 5000
  exports.server = app.listen app.get('port')
  console.log 'Server running'

  # Set up socket
  require './socket'
