
/* public/js/start.js */
var base, boardId, names, ref, tag;

if ((base = String.prototype).startsWith == null) {
  base.startsWith = function(s) {
    return this.slice(0, s.length) === s;
  };
}

ref = Cookies.get();
for (boardId in ref) {
  names = ref[boardId];
  if (boardId.startsWith('_ga')) {
    continue;
  }
  names = JSON.parse(names);
  tag = $('<div>', {
    "class": 'chip white'
  }).append($('<a>', {
    href: "/" + names.singleTokenBoardName + "/" + boardId
  }).css({
    color: 'MediumAquaMarine'
  }).text(names.boardName)).append($('<i>', {
    "class": 'material-icons',
    onclick: "Cookies.remove('" + boardId + "');"
  }).css({
    color: 'MediumAquaMarine'
  }).text('close'));
  $('#previous_boards').append(tag);
}

$(function() {
  return setTimeout(function() {
    return $('#boardName').focus();
  }, 100);
});
