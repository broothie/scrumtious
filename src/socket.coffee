# src/server.coffee becomes:
### server.js ###
# 3rd party imports
io = require('socket.io')(require('./app').server)

# Module imports
db = require('./app').db

activeBoards = []

io.on 'connection', (socket) ->
  boards = db.collection 'boards'
  socket.on 'handshake', (fingerprint) ->
    boards.findOne {'fingerprint': fingerprint}, (err, item) ->
      socket.emit 'initialize', JSON.parse item.data

  socket.on 'clientRequest', (fingerprint) ->
    boards.findOne {'fingerprint': fingerprint}, (err, item) ->
      socket.emit 'clientUpdate', JSON.parse item.data

  socket.on 'serverUpdate', (payload) ->
    boards.findOne

  socket.on 'disconnect', ->
    console.log 'connlost'
