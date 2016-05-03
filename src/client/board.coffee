# src/client/board.coffee becomes:
### public/js/board.js ###

# Globals
button = stickyManager = null

initialize = (stickyData) ->
  stickyManager = new StickyManager stickyData

  # Make add button DOM
  button = $ '<a>', {
    class: 'btn-floating btn-large waves-effect waves-light red'
  }
  .css {
    position: 'fixed'
    left: '90%'
    top: '90%'
  }
  # Add it's event handler
  .click ->
    stickyManager.addSticky()

  # Fill out add button DOM
  button.append($ '<i>', {
    class: 'material-icons'
  }
  .text '+')

  # Add button to page
  $(document.body).append button

# Trap backspaces to prevent back-navigation
$('html').trap [8], ->
$('html').focus()
