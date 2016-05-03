# src/server/backsocket.coffee becomes:
### src/backsocket.js ###
# 3rd party imports
io = require('socket.io')(require('./server').server)
# Module imports
boards = require('./server').db.collection 'boards'

io.on 'connect', (socket) ->
  socket.on 'HANDSHAKE', (fingerprint) ->
    boards.findOne {fingerprint: fingerprint}, (err, item) ->
      socket.emit 'INITIALIZE', item

  socket.on 'CLOSE', (payload) ->
    boards.update {fingerprint: payload.fingerprint}, {$set: {stickyData: payload.stickyData}}


  # socket.on 'CLIENT_REQUEST', (fingerprint) ->
  #   boards.findOne {'fingerprint': fingerprint}, (err, item) ->
  #     socket.emit 'CLIENT_UPDATE', JSON.parse item.data
  #
  # socket.on 'SERVER_UPDATE', (payload) ->
  #   # boards.findOne

  # socket.on 'disconnect', ->
  #   console.log 'connlost'
