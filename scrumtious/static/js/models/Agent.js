
/* scrumtious/static/js/models/Agent.js */
var Agent;

Agent = (function() {
  Agent.prototype.boardId = null;

  function Agent() {
    var myUrl, ref;
    ref = document.location.pathname.split('/'), this.boardId = ref[ref.length - 1];
    myUrl = location.protocol + "//" + document.domain + (location.port ? ':' + location.port : '');
    this.socket = io.connect(myUrl);
    this.socket.on('connect', (function(_this) {
      return function() {
        console.log('Connected');
        return _this.socket.emit('ts_HANDSHAKE', _this.boardId);
      };
    })(this));
    this.socket.on('tc_INITIALIZE', (function(_this) {
      return function(boardInfo) {
        window.noteManager = new NoteManager(_this, boardInfo.notes);
        document.title = boardInfo.boardName + " - Scrumtious Scrumboard";
        Cookies.set(_this.boardId, {
          boardName: boardInfo.boardName,
          singleTokenBoardName: boardInfo.singleTokenBoardName
        });
        return console.log('Initialized');
      };
    })(this));
    window.onbeforeunload = (function(_this) {
      return function() {
        _this.socket.emit('ts_CLOSE', _this.boardId);
        return console.log('Closed');
      };
    })(this);
    this.socket.on('tc_NEW_NOTE', function(payload) {
      return noteManager.newNote(payload);
    });
    this.socket.on('tc_MOVE_NOTE', function(payload) {
      console.log("Move " + payload.nid);
      return noteManager.moveNote(payload.nid, payload.xr, payload.yr);
    });
  }

  Agent.prototype.newNote = function() {
    var button, ref, xr, yr;
    button = $('#add_button');
    ref = [(button.position().left + 50) / window.innerWidth, (button.position().top - 75) / window.innerHeight], xr = ref[0], yr = ref[1];
    return this.socket.emit('ts_NEW_NOTE', {
      boardId: this.boardId,
      xr: xr,
      yr: yr
    });
  };

  Agent.prototype.changeNote = function(nid, content) {
    return this.socket.emit('ts_CHANGE_NOTE', {
      boardId: this.boardId,
      nid: nid,
      content: content
    });
  };

  Agent.prototype.moveNote = function(nid, xr, yr) {
    return this.socket.emit('ts_MOVE_NOTE', {
      boardId: this.boardId,
      nid: nid,
      xr: xr,
      yr: yr
    });
  };

  Agent.prototype.deleteNote = function(nid) {
    return this.socket.emit('ts_DELETE_NOTE', {
      boardId: this.boardId,
      nid: nid
    });
  };

  return Agent;

})();
