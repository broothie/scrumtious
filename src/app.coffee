# src/app.coffee becomes:
### app.js ###
# Node imports
path = require 'path'
# 3rd party imports
express = require 'express'
mongodb = require 'mongodb'


# Create Express object
app = exports.app = express()

# Set up static dir and Jade
app.use express.static path.join __dirname, 'public'
app.set 'view engine', 'jade'

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

# Connect to database
mongodb.MongoClient.connect process.env.MONGODB_URI or 'mongodb://localhost:27017/scrumtious', (err, database) ->
  if err
    console.log err
    process.exit 1

  exports.db = database
  console.log 'Database connection ready'

  # Set up routes
  app.use '/', require './routes'

  # Start server
  app.set 'port', process.env.PORT or 5000
  server = exports.server = app.listen app.get('port'), ->
    host = server.address().address
    port = app.get 'port'
    console.log "Application server running at http://#{host}:#{port}"

  # Set up socket
  require './socket'
