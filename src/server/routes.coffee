# src/server/routes.coffee becomes:
### src/routes.js ###
# 3rd party imports
module.exports = router = require('express').Router()
crypto = require 'crypto'

# Module imports
db = require('./server').db
boards = db.collection 'boards'

# Index routes
router.get '/', (req, res) ->
  res.render 'board'
router.post '/', (req, res) ->
  # Get board name from user post
  boardName = req.body.boardName
  cleanBoardName = boardName.toLowerCase().replace(' ', '-').replace(/[^0-9a-z_-]/gi, '')

  # Create hash object and get date to hash with
  shasum = crypto.createHash 'sha1'
  date = new Date()

  # Hash with board name and date
  shasum.update boardName + date
  fingerprint = shasum.digest 'hex'

  # Add board to database
  boards.insert {
    fingerprint: fingerprint
    data: JSON.stringify {
      boardName: boardName
      cleanBoardName: cleanBoardName
      stickylist: []
    }
  }

  # Redirect user to their new board
  res.redirect "/#{cleanBoardName}/#{fingerprint}"

# Board route
router.get '/:cleanBoardName/:fingerprint', (req, res) ->
  boards.findOne {fingerprint: req.params.fingerprint}, (err, item) ->
    if item? and JSON.parse(item.data).cleanBoardName == req.params.cleanBoardName
      res.render 'board'
    else
      res.redirect '/'
