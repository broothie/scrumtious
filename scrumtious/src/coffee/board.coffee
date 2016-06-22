# scrumtious/src/coffee/board.coffee becomes:
### scrumtious/static/js/board.js ###

# Globals for DOM
agent = null
noteManager = null

$ ->
  agent = new Agent()

  # Wait and add clipboard copying functionality
  setTimeout ->
    $('#link_button').attr 'data-clipboard-text', window.location.href
    clipboard = new Clipboard '#link_button'
    clipboard.on 'success', (event) ->
      Materialize.toast('Link copied!', 1500)
  , 100

# Send link functionality
sendLink = ->
  subject = "Scrumtio.us scrumboard for our project"
  body = "Check it out: #{window.location.href}"
  window.open "mailto:?subject=#{subject}&body=#{body}"

sendEmails = ->
  emailString = prompt 'List the email addresses you want to send this scrumboard to, separated by commas'
  [..., boardId] = document.location.pathname.split '/'
  $.post '/email', {
    boardId: boardId
    emailString: emailString
  }
