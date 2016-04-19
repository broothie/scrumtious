# src/server.coffee becomes:
### server.js ###
# 3rd party imports
io = require('socket.io')(require('./app').server)

# Module imports
db = require('./app').db

io.on 'connection', (socket) ->
  socket.on 'handshake', (fingerprint) ->
    db.collection('boards').findOne {'fingerprint': fingerprint}, (err, item) ->
      socket.emit 'initialize', item.data

  socket.on 'disconnect', ->
    console.log 'connlost'
