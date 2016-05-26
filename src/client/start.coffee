# src/client/start.coffee becomes:
### public/js/start.js ###

String::startsWith ?= (s) -> @[...s.length] is s

for boardId, names of Cookies.get()
  continue if boardId.startsWith '_ga'
  names = JSON.parse names

  tag = $ '<div>', {
    class: 'chip white'
  }
  .append($ '<a>', {
    href: "/#{names.cleanBoardName}/#{boardId}"
  }
  .css {
    color: 'MediumAquaMarine'
  }
  .text names.boardName)
  .append($ '<i>', {
    class: 'material-icons'
    onclick: "Cookies.remove('#{boardId}');"
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
