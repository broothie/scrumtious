
/* public/js/socket.js */
var Server;

Server = (function() {
  Server.prototype.boardId = null;

  function Server() {
    var myUrl, ref;
    ref = document.location.pathname.split('/'), this.boardId = ref[ref.length - 1];
    myUrl = location.protocol + "//" + document.domain + (location.port ? ':' + location.port : '');
    this.socket = io.connect(myUrl);
    this.socket.on('connect', function() {
      return this.socket.emit('HANDSHAKE', boardId);
    });
    this.socket.on('INITIALIZE', function(payload) {
      initialize(payload.stickyData);
      return document.title = payload.boardName + " - Scrumtious Scrumboard";
    });
    window.onbeforeunload = function() {
      this.socket.emit('CLOSE', {
        boardId: boardId,
        stickyData: stickyManager.data()
      });
      return console.log('Closed');
    };
  }

  return Server;

})();
