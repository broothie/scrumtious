# src/client/start.coffee becomes:
### public/js/start.js ###

String::startsWith ?= (s) -> @[...s.length] is s

for fingerprint, names of Cookies.get()
  continue if fingerprint.startsWith '_ga'
  names = JSON.parse names

  tag = $ '<div>', {
    class: 'chip white'
  }
  .append($ '<a>', {
    href: "/#{names.cleanBoardName}/#{fingerprint}"
  }
  .css {
    color: 'MediumAquaMarine'
  }
  .text names.boardName)
  .append($ '<i>', {
    class: 'material-icons'
    onclick: "Cookies.remove('#{fingerprint}');"
  }
  .css {
    color: 'MediumAquaMarine'
  }
  .text 'close')

  $('#previous_boards').append tag

$ ->
  setTimeout ->
    $('#boardName').focus()
  , 100
