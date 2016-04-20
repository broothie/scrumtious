# src/server/socket.coffee becomes:
### src/socket.js ###
# 3rd party imports
io = require('socket.io')(require('./server').server)

# Module imports
db = require('./server').db

activeBoards = []

io.on 'connect', (socket) ->
  boards = db.collection 'boards'

  socket.on 'HANDSHAKE', (fingerprint) ->
    boards.findOne {fingerprint: fingerprint}, (err, item) ->
      socket.emit 'INITIALIZE', JSON.parse item.data

  # socket.on 'CLIENT_REQUEST', (fingerprint) ->
  #   boards.findOne {'fingerprint': fingerprint}, (err, item) ->
  #     socket.emit 'CLIENT_UPDATE', JSON.parse item.data
  #
  # socket.on 'SERVER_UPDATE', (payload) ->
  #   # boards.findOne

  # socket.on 'disconnect', ->
  #   console.log 'connlost'
