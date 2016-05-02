# src/client/app.coffee becomes:
### public/js/app.js ###

# Some globals
body = $ document.body
# stickyIdTracker = 0
# stickyList = []

# Called on document readiness
$ ->
  # Make add button DOM
  button = $ '<a>', {
    class: 'btn-floating btn-large waves-effect waves-light red'
  }
  .attr 'id', 'button'
  .css {
    position: 'fixed'
    left: '90%'
    top: '90%'
  }
  # Add it's event handler
  .click ->
    new Sticky 50, 50

  # Fill out add button DOM
  button.append($ '<i>', {
    class: 'material-icons'
  }
  .text '+')

  # Add button to page
  body.append button


# For keeping data on stickies
class Sticky
  @stickyIdTracker: 0
  @stickyList: []

  constructor: (x, y, @content='') ->
    @idn = Sticky.stickyIdTracker++
    @editMode = false

    # Sticky element
    @sticky = $ '<sticky>'
    .css {
      left: x + 'px'
      top: y + 'px'
    }
    .draggable()
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
      mode: Medium.paritalMode
      autofocus: true
    }

    console.log @sticky.css('left'), @sticky.css('top')

    @sticky.dblclick (event) =>
      if @editMode
        # Switch out of edit mode
        # Style
        @sticky.draggable 'enable'
        @stickyDiv.removeClass 'lighten-5'
        @stickyDiv.addClass 'lighten-2'

        # Get content and remove text entry
        @textEntry.remove()
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
        @stickyDiv.addClass 'lighten-5'

        # Get content and remove p
        @content = @textTag.text()
        @textTag.remove()

        # Add text entry
        @textEntry.text @content
        @contentDiv.append @textEntry
        @textEntry.focus()
        @editMode = true

    body.append @sticky
    @sticky.dblclick()
