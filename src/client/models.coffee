# src/client/models.coffee becomes:
### public/js/models.js ###


class Server
  boardId: null
  constructor: ->
    # Create socket
    [..., @boardId] = document.location.pathname.split '/'
    myUrl = "#{location.protocol}//#{document.domain}#{if location.port then ':' + location.port else ''}"
    @socket = io.connect myUrl

    # Define socket basics
    @socket.on 'connect', =>
      @socket.emit 'HANDSHAKE', @boardId

    @socket.on 'INITIALIZE', (payload) =>
      document.title = "#{payload.boardName} - Scrumtious Scrumboard"

    window.onbeforeunload = =>
      @socket.emit 'CLOSE', {
        boardId: @boardId
        stickyData: stickyManager.data()
      }
      console.log 'Closed'

    # Define server receive events
    # @socket.on 'tc_NEW_STICKY', (payload) ->
    #   stickyManager.addSticky



  # Define server send events
  newSticky: (x, y) ->
    @socket.emit 'ts_NEW_STICKY', {
      boardId: @boardId
      xr: x / window.innerWidth
      yr: y / window.innerHeight
    }

  changeSticky: (idn, content) ->
    @socket.emit 'ts_CHANGE_STICKY', {
      boardId: @boardId
      idn: idn
      content: content
    }

  moveSticky: (idn, x, y) ->
    @socket.emit 'ts_MOVE_STICKY', {
      boardId: @boardId
      idn: idn
      xr: x / window.innerWidth
      yr: y / window.innerHeight
    }

  deleteSticky: (idn) ->
    @socket.emit 'ts_DELETE_STICKY', {
      boardId: @boardId
      idn: idn
    }


# For keeping data on stickies
class StickyManager
  stickyList: []

  constructor: (stickyData=[]) ->
    for sticky in stickyData
      [x, y] = [sticky.xs * window.innerWidth, sticky.ys * window.innerHeight]
      @addSticky new Sticky sticky.content, x, y

  addSticky: (sticky) ->
    @stickyList.push sticky

  newSticky: ->
    button = $ '#add_button'
    [x, y] = [button.position().left + 50, button.position().top - 75]
    sticky = new Sticky '', x, y
    @addSticky sticky
    sticky.textEntry.focus()

  removeSticky: (sticky) ->
    @stickyList.splice @stickyList.indexOf sticky.destroy(), 1

  data: ->
    sticky.data() for sticky in @stickyList


# Sticky object
class Sticky
  constructor: (content, x, y) ->
    # Sticky element
    @sticky = $ '<sticky>'
    .css {
      left: x + 'px'
      top: y + 'px'
    }
    # Add top div
    .append($ '<div>', {
      class: 'card hoverable'
    }
    .css {
      display: 'block'
      'background-color': 'MediumAquaMarine'
    }
    # Add interactive div
    .append($ '<div>'
    .append(handle = $ '<i>', {
      class: 'material-icons'
    }
    .text 'reorder')
    .append($ '<i>', {
      class: 'material-icons'
    }
    .css {
      float: 'right'
    }
    .text 'close'
    .click =>
      stickyManager.removeSticky this
    ))
    # Add content div
    .append($ '<div>', {
      class: 'card-content white-text'
    }
    .css {
      'padding-top': '0px'
    }
    # Add text entry
    .append(@textEntry = $ '<div>'
    .css {
      height: '100%'
    }
    .text content)))
    new Medium {
      element: @textEntry.get 0
      mode: Medium.partialMode
      autofocus: true
    }

    @sticky.draggable({
      handle: handle
      stop: (event, ui) =>
        alert @sticky.position().left / window.innerWidth
    })
    .css {
      position: 'fixed'
    }

    $(document.body).append @sticky

  data: ->
    {
      content: @textEntry.text().replace(/[^-0-9a-z_ ]/gi, '')
      xs: @sticky.position().left / window.innerWidth
      ys: @sticky.position().top / window.innerHeight
    }

  destroy: ->
    alert @textEntry.text()
    @sticky.remove()
