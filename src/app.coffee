### app.coffee ###
# Node imports
path = require 'path'
# 3rd party imports
express = require 'express'


# Make Express.js app
app = exports.app = express()

# Set up public folder and Jade view engine
app.use express.static path.join __dirname, 'public'
app.set 'view engine', 'jade'

# Set up session and cookies
# TODO Use a more secure secret key for the session setup
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
server = exports.server = app.listen app.get('port'), ->
  host = server.address().address
  port = app.get 'port'
  console.log "Application server running at http://#{host}:#{port}"

require './server'
