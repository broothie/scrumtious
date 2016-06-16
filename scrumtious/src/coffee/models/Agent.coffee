# scrumtious/cs/models/Agent.coffee becomes:
### scrumtious/static/js/models/Agent.js ###

class Agent
  boardId: null

  constructor: ->
    # Create socket
    [..., @boardId] = document.location.pathname.split '/'
    myUrl = "#{location.protocol}//#{document.domain}#{if location.port then ':' + location.port else ''}"
    @socket = io.connect myUrl

    ## Define socket basics
    @socket.on 'connect', =>
      console.log 'Connected'
      @socket.emit 'ts_HANDSHAKE', @boardId

    @socket.on 'tc_INITIALIZE', (boardInfo) =>
      # Make note manager, change title, add cookie
      window.noteManager = new NoteManager this, boardInfo.notes
      document.title = "#{boardInfo.boardName} - Scrumtious Scrumboard"
      Cookies.set @boardId, {
        boardName: boardInfo.boardName
        singleTokenBoardName: boardInfo.singleTokenBoardName
      }
      console.log 'Initialized'

    window.onbeforeunload = =>
      # Tell server of user close
      @socket.emit 'ts_CLOSE', @boardId
      console.log 'Closed'

    ## Define server receive events
    @socket.on 'tc_NEW_NOTE', (payload) ->
      noteManager.newNote payload

    @socket.on 'tc_CHANGE_NOTE', (payload) ->
      noteManager.changeNote payload.nid, payload.content

    @socket.on 'tc_MOVE_NOTE', (payload) ->
      noteManager.moveNote payload.nid, payload.xr, payload.yr

    @socket.on 'tc_DELETE_NOTE', (nid) ->
      noteManager.deleteNote nid



  # Define server send events
  newNote: ->
    button = $ '#add_button'
    [xr, yr] = [(button.position().left + 50)/window.innerWidth,
      (button.position().top - 75)/window.innerHeight]
    @socket.emit 'ts_NEW_NOTE', {
      boardId: @boardId
      xr: xr
      yr: yr
    }

  changeNote: (nid, content) ->
    @socket.emit 'ts_CHANGE_NOTE', {
      boardId: @boardId
      nid: nid
      content: content
    }

  moveNote: (nid, xr, yr) ->
    @socket.emit 'ts_MOVE_NOTE', {
      boardId: @boardId
      nid: nid
      xr: xr
      yr: yr
    }

  deleteNote: (nid) ->
    @socket.emit 'ts_DELETE_NOTE', {
      boardId: @boardId
      nid: nid
    }
