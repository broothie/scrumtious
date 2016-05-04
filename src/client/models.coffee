# src/client/models.coffee becomes:
### public/js/models.js ###

# For keeping data on stickies
class StickyManager
  stickyList: []

  constructor: (stickyData=[]) ->
    for sticky in stickyData
      [x, y] = [sticky.xs * window.innerWidth, sticky.ys * window.innerHeight]
      @stickyList.push new Sticky sticky.content, x, y

  newSticky: ->
    button = $ '#add_button'
    [x, y] = [button.position().left + 50, button.position().top - 75]
    sticky = new Sticky '', x, y
    @stickyList.push sticky
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
      class: 'card'
    }
    .css {
      display: 'block'
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
    @sticky.remove()
