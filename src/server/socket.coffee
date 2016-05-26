# src/server/socket.coffee becomes:
### socket.js ###
# 3rd party imports
io = require('socket.io')(require('./server').server)
# Module imports
db = require('./server').db
boards = db.collection 'boards'

# On new socket connection, define handlers
io.on 'connect', (socket) ->
  socket.on 'HANDSHAKE', (boardId) ->
    boards.findOne {boardId: boardId}, (err, item) ->
      socket.emit 'INITIALIZE', item

  socket.on 'CLOSE', (payload) ->
    boards.update {boardId: payload.boardId}, {$set: {stickyData: payload.stickyData}}

  # socket.on 'CLIENT_REQUEST', (boardId) ->
  #   boards.findOne {'boardId': boardId}, (err, item) ->
  #     socket.emit 'CLIENT_UPDATE', JSON.parse item.data
  #
  # socket.on 'SERVER_UPDATE', (payload) ->
  #   # boards.findOne
