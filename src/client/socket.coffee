# src/client/frontsocket.coffee becomes:
### public/js/frontsocket.js ###

# Globals
myUrl = "#{location.protocol}//#{document.domain}#{if location.port then ':' + location.port else ''}"
socket = io.connect myUrl
fingerprint = null

socket.on 'connect', ->
  [..., fingerprint] = document.location.pathname.split '/'
  socket.emit 'HANDSHAKE', fingerprint

socket.on 'INITIALIZE', (payload) ->
  initialize payload.stickyData
  document.title = "#{payload.boardName} - Scrumtious Scrumboard"

window.onbeforeunload = ->
  socket.emit 'CLOSE', {
    fingerprint: fingerprint
    stickyData: stickyManager.data()
  }
  console.log 'Closed'
