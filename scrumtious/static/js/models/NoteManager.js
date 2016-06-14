
/* scrumtious/static/js/models/NoteManager.js */
var NoteManager;

NoteManager = (function() {
  NoteManager.prototype.notes = {};

  function NoteManager(agent, noteDatas) {
    var i, len, noteData;
    this.agent = agent;
    for (i = 0, len = noteDatas.length; i < len; i++) {
      noteData = noteDatas[i];
      this.addNote(new Note(this.agent, noteData.content, noteData.xr, noteData.yr));
    }
  }

  NoteManager.prototype.addNote = function(note) {
    return this.notes[note.nid] = note;
  };

  NoteManager.prototype.newNote = function(noteData) {
    return this.addNote(new Note(this.agent, noteData.nid, noteData.content, noteData.xr, noteData.yr));
  };

  NoteManager.prototype.moveNote = function(nid, xr, yr) {
    return this.getNote(nid).move(xr, yr);
  };

  NoteManager.prototype.changeNote = function(nid, content) {
    return this.getNote(nid).change(content);
  };

  NoteManager.prototype.getNote = function(nid) {
    return this.notes[nid];
  };

  NoteManager.prototype.removeNote = function(note) {
    return this.notes.splice(this.notes.indexOf(note.destroy(), 1));
  };

  NoteManager.prototype.data = function() {
    var nid, note, ref, results;
    ref = this.notes;
    results = [];
    for (nid in ref) {
      note = ref[nid];
      results.push(note);
    }
    return results;
  };

  return NoteManager;

})();
