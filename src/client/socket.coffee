# src/client/socket.coffee becomes:
### public/js/socket.js ###

myUrl = "#{location.protocol}//#{document.domain}#{if location.port then ':' + location.port else ''}"
socket = io.connect myUrl

socket.on 'connect', ->
  [..., fingerprint] = document.location.pathname.split '/'
  socket.emit 'HANDSHAKE', fingerprint

socket.on 'INITIALIZE', (payload) ->
  # TODO: Populate board
  document.title = "#{payload.boardName} - Scrumtious Scrumboard"

socket.on 'disconnect', ->
  # TODO: Emit final state of board
