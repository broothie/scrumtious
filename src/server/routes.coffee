# src/server/routes.coffee becomes:
### routes.js ###
# Standard imports
path = require 'path'
crypto = require 'crypto'
# 3rd party imports
module.exports = router = require('express').Router()
Cookies = require 'cookies'
# Module imports
boards = require('./server').db.collection 'boards'
records = require('./server').records

# Index routes
router.get '/', (req, res) ->
  res.sendFile path.join  __dirname, 'public/views/start.html'
router.post '/', (req, res) ->
  # Get board name from user post
  boardName = req.body.boardName.replace /[^-0-9a-z_ ]/gi, ''
  cleanBoardName = boardName.toLowerCase().replace ' ', '-'

  # Create hash object and get date to hash with
  shasum = crypto.createHash 'sha1'
  date = new Date()

  # Hash with board name and date
  shasum.update boardName + date
  boardId = shasum.digest 'hex'

  # Add board to database
  boards.insert {
    boardId: boardId
    boardName: boardName
    cleanBoardName: cleanBoardName
    maxNid: 0
    stickyData: []
  }, ->
    # Redirect user to their new board
    res.redirect "/#{cleanBoardName}/#{boardId}"

# Board route
router.get '/:cleanBoardName/:boardId', (req, res) ->
  boardId = req.params.boardId
  boards.findOne {boardId: boardId}, (err, item) ->
    if item? and item.cleanBoardName == req.params.cleanBoardName
      # Add cookie
      cookies = new Cookies req, res
      cookies.set item.boardId, JSON.stringify({
        boardName: item.boardName
        cleanBoardName: item.cleanBoardName
      }), {
        maxAge: 1000 * 60 * 60 * 24 * 365
        httpOnly: false
      }

      records.recordExists(boardId).then (exists) ->
        if exists
          

      res.sendFile path.join __dirname, 'public/views/board.html'
    else
      res.redirect '/'
