# src/routes.coffee becomes:
### routes.js ###
# 3rd party imports
router = require('express').Router()
crypto = require 'crypto'

# Module imports
db = require('./app').db

# Index route
router.get '/', (req, res) ->
  # When linked to route, redirect to start page
  res.redirect '/start'

# Start routes
router.get '/start', (req, res) ->
  res.render 'start'
router.post '/start', (req, res) ->
  # Get board name from user post
  boardname = req.body.boardname

  # Create hash object and get date to hash with
  shasum = crypto.createHash 'sha1'
  date = new Date()

  # Hash with board name and date
  shasum.update boardname + date
  fingerprint = shasum.digest 'hex'

  # Add board to database
  db.collection('boards').insert {
    fingerprint: fingerprint
    data: JSON.stringify {
      name: boardname
      stickylist: []
    }
  }

  # Redirect user to their new board
  res.redirect "/board/#{fingerprint}"

# Board route
router.get '/board', (req, res) ->
  res.redirect '/start'
router.get '/board/:fingerprint', (req, res) ->
  res.render 'board'
router.post '/board/:fingerprint', (req, res) ->
  # body...



module.exports = router
