# src/server.coffee becomes:
### server.js ###

# 3rd party imports
eurecaio = require 'eureca.io'

# Make Eureca server
eurecaServer = new eurecaio.Server {
  allow: ['hand']
}
# Attach to express server
eurecaServer.attach require('./app').server

# onConnect
eurecaServer.onConnect (connection) ->
  console.log "Connected with #{connection.id}"
  eurecaServer.getClient(connection.id).offer 'hand'
