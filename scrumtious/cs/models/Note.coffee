# scrumtious/cs/models/Note.coffee becomes:
### scrumtious/static/js/models/Note.js ###


class Note
  constructor: (@agent, @nid, content, xr, yr) ->
    # Sticky element
    @domNote = $ '<note>'
    .css {
      left: xr * window.innerWidth + 'px'
      top: yr * window.innerHeight + 'px'
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
      @agent.removeNote
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

    @domNote.draggable({
      handle: handle
      stop: (event, ui) =>
        noteInfo = @data()
        @agent.moveNote noteInfo.nid, noteInfo.xr, noteInfo.yr
    })
    .css {
      position: 'fixed'
    }

    $(document.body).append @domNote

  move: (xr, yr) ->
    @domNote.css {
      left: xr * window.innerWidth + 'px'
      top: yr * window.innerHeight + 'px'
    }

  change: (content) ->
    @textEntry.text(content)

  data: ->
    {
      nid: @nid
      content: @textEntry.text().replace(/[^-0-9a-z_ ]/gi, '')
      xr: @domNote.position().left / window.innerWidth
      yr: @domNote.position().top / window.innerHeight
    }

  destroy: ->
    alert @textEntry.text()
    @domNote.remove()
