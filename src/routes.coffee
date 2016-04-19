# src/routes.coffee becomes:
### routes.js ###
# 3rd party imports
router = require('express').Router()
crypto = require 'crypto'

# Module imports
db = require('./app').db
boards = db.collection 'boards'

# Index routes
router.get '/', (req, res) ->
  res.render 'start'
router.post '/', (req, res) ->
  # Get board name from user post
  boardname = req.body.boardname
  cleanboardname = boardname.toLowerCase().replace(' ', '-').replace(/[^0-9a-z_-]/gi, '')

  # Create hash object and get date to hash with
  shasum = crypto.createHash 'sha1'
  date = new Date()

  # Hash with board name and date
  shasum.update boardname + date
  fingerprint = shasum.digest 'hex'

  # Add board to database
  boards.insert {
    fingerprint: fingerprint
    data: JSON.stringify {
      boardname: boardname
      cleanboardname: cleanboardname
      stickylist: []
    }
  }

  # Redirect user to their new board
  res.redirect "/#{cleanboardname}/#{fingerprint}"

# Board route
router.get '/:cleanboardname/:fingerprint', (req, res) ->
  boards.findOne {fingerprint: req.params.fingerprint}, (err, item) ->
    if item? and JSON.parse(item.data).cleanboardname == req.params.cleanboardname
      res.render 'board'
    else
      res.redirect '/'


module.exports = router
