
/* scrumtious/static/js/models/Note.js */
var Note;

Note = (function() {
  function Note(agent, nid, content, xr, yr) {
    var handle;
    this.agent = agent;
    this.nid = nid;
    this.domNote = $('<note>').css({
      left: xr * window.innerWidth + 'px',
      top: yr * window.innerHeight + 'px'
    }).append($('<div>', {
      "class": 'card hoverable'
    }).css({
      display: 'block',
      'background-color': 'MediumAquaMarine'
    }).append($('<div>').append(handle = $('<i>', {
      "class": 'material-icons'
    }).text('reorder')).append($('<i>', {
      "class": 'material-icons'
    }).css({
      float: 'right'
    }).text('close').click((function(_this) {
      return function() {
        return _this.agent.deleteNote(_this.nid);
      };
    })(this)))).append($('<div>', {
      "class": 'card-content white-text'
    }).css({
      'padding-top': '0px'
    }).append(this.textEntry = $('<div>').css({
      height: '100%',
      cursor: 'text'
    }).text(content))));
    this.textEntry.focusout((function(_this) {
      return function() {
        var noteData;
        noteData = _this.data();
        _this.agent.changeNote(noteData.nid, noteData.content);
        return document.activeElement.blur();
      };
    })(this));
    this.medium = new Medium({
      element: this.textEntry.get(0),
      mode: Medium.inlineMode,
      keyContext: {
        'enter': (function(_this) {
          return function() {
            return _this.textEntry.focusout();
          };
        })(this),
        'shift+enter': function() {
          return alert('shiftentered');
        }
      }
    });
    this.domNote.draggable({
      handle: handle,
      stop: (function(_this) {
        return function(event, ui) {
          var noteInfo;
          noteInfo = _this.data();
          return _this.agent.moveNote(noteInfo.nid, noteInfo.xr, noteInfo.yr);
        };
      })(this)
    }).css({
      position: 'fixed'
    });
    $(document.body).append(this.domNote);
  }

  Note.prototype.move = function(xr, yr) {
    return this.domNote.css({
      left: xr * window.innerWidth + 'px',
      top: yr * window.innerHeight + 'px'
    });
  };

  Note.prototype.change = function(content) {
    return this.textEntry.text(content);
  };

  Note.prototype.data = function() {
    return {
      nid: this.nid,
      content: this.textEntry.text().replace(/[^-0-9a-z_ ]/gi, ''),
      xr: this.domNote.position().left / window.innerWidth,
      yr: this.domNote.position().top / window.innerHeight
    };
  };

  Note.prototype.destroy = function() {
    this.medium.destroy();
    return this.domNote.remove();
  };

  return Note;

})();
