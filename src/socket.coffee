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





# eurecaio = require 'eureca.io'
#
# # Make Eureca server
# eurecaServer = new eurecaio.Server {
#   allow: ['handshakeToServer']
# }
# # Attach to express server
# eurecaServer.attach require('./app').server
#
# dbTable = {}
#
# # onConnect
# eurecaServer.onConnect (connection) ->
#   console.log "Connected with #{connection.id}"
#   eurecaServer.getClient(connection.id).handshakeToClient 'offer'
#
# eurecaServer.exports.handshakeToServer = (payload) ->
#   if payload.error?
#     console.log 'URL error on client side'
#
#   console.log 'handshake back!'
#   console.log payload
