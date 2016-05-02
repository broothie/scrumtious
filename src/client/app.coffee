# src/client/app.coffee becomes:
### public/js/app.js ###

# Some globals
body = $ document.body
# stickyIdTracker = 0
stickyList = []

# Called on document readiness
$ ->
  # Make add button DOM
  button = $ '<a>', {
    class: 'btn-floating btn-large waves-effect waves-light red'
  }
  .css {
    position: 'fixed'
    top: '90%'
    left: '90%'
  }
  # Add it's event handler
  .click ->
    console.log 'Adding sticky...'
    stickyList.push new Sticky 50, 50

  # Fill out add button DOM
  button.append($ '<i>', {
    class: 'material-icons'
    text: '+'
  })

  # Add button to page
  body.append button


# For keeping data on stickies
class Sticky
  @stickyIdTracker: 0

  constructor: (x, y) ->
    @idn = Sticky.stickyIdTracker++
    @editMode = true
    # Sticky element
    @sticky = $ '<sticky>'
    .css {
      position: 'relative'
      display: 'block'
      width: '150px'
      height: '150px'
      cursor: 'pointer'
      left: x + 'px'
      top: y + 'px'
    }
    .draggable()
    .append(@stickyDiv = $ '<div>', {
      class: 'card yellow lighten-5'
    }
    .css {
      height: '100%'
    }
    .append(@contentDiv = $ '<div>', {
      class: 'card-content black-text'
    }
    .append @textTag = $ '<p>'))
    
    new Medium {
      element: @textTag.get(0)
    }


    @sticky.dblclick (event) =>
      if @editMode
        @editMode = false
        @stickyDiv.removeClass 'lighten-5'
        @stickyDiv.addClass 'lighten-2'
      else
        @editMode = true
        @stickyDiv.removeClass 'lighten-2'
        @stickyDiv.addClass 'lighten-5'

    body.append @sticky
