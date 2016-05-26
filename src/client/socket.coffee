# src/client/socket.coffee becomes:
### public/js/socket.js ###


class Server
  boardId: null
  constructor: ->
    [..., @boardId] = document.location.pathname.split '/'
    myUrl = "#{location.protocol}//#{document.domain}#{if location.port then ':' + location.port else ''}"
    @socket = io.connect myUrl

    @socket.on 'connect', ->
      @socket.emit 'HANDSHAKE', boardId

    @socket.on 'INITIALIZE', (payload) ->
      initialize payload.stickyData
      document.title = "#{payload.boardName} - Scrumtious Scrumboard"

    window.onbeforeunload = ->
      @socket.emit 'CLOSE', {
        boardId: boardId
        stickyData: stickyManager.data()
      }
      console.log 'Closed'
