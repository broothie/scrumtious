# src/server/models/ActiveBoard.coffee becomes:
### models/ActiveBoard.js ###

module.exports =
class ActiveBoard
  constructor: (@io=require('../server').socketio, @namespace) ->
