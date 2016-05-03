# src/client/models.coffee becomes:
### public/js/models.js ###

# For keeping data on stickies
class StickyManager
  stickyList: []

  constructor: (stickyData=[]) ->
    for sticky in stickyData
      [x, y] = [sticky.xs * window.innerWidth, sticky.ys * window.innerHeight]
      @stickyList.push new Sticky sticky.content, x, y

  addSticky: ->
    [x, y] = [button.position().left - 145, button.position().top - 145]
    sticky = new Sticky '', x, y
    @stickyList.push sticky
    sticky.sticky.dblclick()

  removeSticky: (sticky) ->
    @stickyList.splice @stickyList.indexOf sticky.destroy(), 1

  data: ->
    sticky.data() for sticky in @stickyList


class Sticky
  constructor: (@content, x, y) ->
    @editMode = false

    # Sticky element
    @sticky = $ '<sticky>'
    .draggable()
    .css {
      left: x + 'px'
      top: y + 'px'
      position: 'fixed'
    }
    # Add top div
    .append(@stickyDiv = $ '<div>', {
      class: 'card yellow lighten-2'
    }
    .css {
      height: '100%'
    }
    # Add content div
    .append(@contentDiv = $ '<div>', {
      class: 'card-content black-text'
    }
    .css {
      height: '100%'
    }
    # Add content p
    .append(@textTag = $ '<p>'
    .css {
      height: '100%'
    }
    .text @content)))

    # Make text entry
    @textEntry = $ '<div>'
    .css {
      height: '100%'
    }
    new Medium {
      element: @textEntry.get 0
      mode: Medium.partialMode
      autofocus: true
    }

    @sticky.dblclick (event) =>
      if @editMode
        # Switch out of edit mode
        # Style
        @sticky.draggable 'enable'
        @stickyDiv.removeClass 'lighten-4'
        @stickyDiv.addClass 'lighten-2'

        # Get content and remove text entry
        @textEntry.detach()
        @content = @textEntry.text()

        # Add p
        @textTag.text @content
        @contentDiv.append @textTag
        @editMode = false
      else
        # Switch into edit mode
        # Style
        @sticky.draggable 'disable'
        @stickyDiv.removeClass 'lighten-2'
        @stickyDiv.addClass 'lighten-4'

        # Get content and remove p
        @content = @textTag.text()
        @textTag.detach()

        # Add text entry
        @textEntry.text @content
        @contentDiv.append @textEntry
        @textEntry.focus()
        @editMode = true

    $(document.body).append @sticky

  data: ->
    {
      content: @content
      xs: @sticky.position().left / window.innerWidth
      ys: @sticky.position().top / window.innerHeight
    }

  destroy: ->
    @sticky.remove()
