# src/server/routes.coffee becomes:
### routes.js ###
# Standard imports
path = require 'path'
crypto = require 'crypto'
# 3rd party imports
module.exports = router = require('express').Router()
Cookies = require 'cookies'
validator = require 'validator'
# postmark = require('postmark')(process.env.POSTMARK_API_TOKEN)
# Module imports
boards = require('./server').db.collection 'boards'

# Index routes
router.get '/', (req, res) ->
  res.sendFile path.join  __dirname, 'public/views/start.html'
router.post '/', (req, res) ->
  # Get board name from user post
  boardName = req.body.boardName.replace(/[^-0-9a-z_ ]/gi, '')
  cleanBoardName = boardName.toLowerCase().replace(' ', '-')

  # Create hash object and get date to hash with
  shasum = crypto.createHash 'sha1'
  date = new Date()

  # Hash with board name and date
  shasum.update boardName + date
  fingerprint = shasum.digest 'hex'

  # if validator.isEmail req.body.email
  #   # Use postmark

  # Add board to database
  boards.insert {
    fingerprint: fingerprint
    boardName: boardName
    cleanBoardName: cleanBoardName
    stickyData: []
  }

  # Add cookie
  cookies = new Cookies req, res
  cookies.set fingerprint, JSON.stringify({
    boardName: boardName
    cleanBoardName: cleanBoardName
  }), {
    maxAge: 1000 * 60 * 60 * 24 * 365
    httpOnly: false
  }

  # Redirect user to their new board
  res.redirect "/#{cleanBoardName}/#{fingerprint}"

# Board route
router.get '/:cleanBoardName/:fingerprint', (req, res) ->
  boards.findOne {fingerprint: req.params.fingerprint}, (err, item) ->
    if item? and item.cleanBoardName == req.params.cleanBoardName
      res.sendFile path.join __dirname, 'public/views/board.html'
    else
      res.redirect '/'

# router.post '/:cleanBoardName/:fingerprint'
#   postmark.send
