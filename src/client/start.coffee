# src/client/start.coffee becomes:
### public/js/start.js ###

for fingerprint, names of Cookies.get()
  names = JSON.parse names
  tag = $ '<a>', {
    href: "/#{names.cleanBoardName}/#{fingerprint}"
  }
  tag.append($ '<div>', {
    class: 'chip'
  }
  .text names.boardName)
  $('#previous_boards').append tag

$ ->
  setTimeout ->
    $('#boardName').focus()
  , 100
