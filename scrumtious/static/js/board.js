
/* public/js/board.js */
var agent, noteManager, sendLink;

agent = null;

noteManager = null;

$(function() {
  agent = new Agent();
  return setTimeout(function() {
    var clipboard;
    $('#link_button').attr('data-clipboard-text', window.location.href);
    clipboard = new Clipboard('#link_button');
    return clipboard.on('success', function(event) {
      return Materialize.toast('Link copied!', 1500);
    });
  }, 100);
});

sendLink = function() {
  var body, subject;
  subject = "Scrumtio.us scrumboard for our project";
  body = "Check it out: " + window.location.href;
  return window.open("mailto:?subject=" + subject + "&body=" + body);
};
