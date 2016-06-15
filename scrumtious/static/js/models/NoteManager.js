
/* scrumtious/static/js/models/NoteManager.js */
var NoteManager;

NoteManager = (function() {
  NoteManager.prototype.notes = {};

  function NoteManager(agent, noteDatas) {
    var nid, noteData;
    this.agent = agent;
    for (nid in noteDatas) {
      noteData = noteDatas[nid];
      console.log(noteData);
      this.addNote(noteData);
    }
  }

  NoteManager.prototype.addNote = function(noteData) {
    return this.notes[noteData.nid] = new Note(this.agent, noteData.nid, noteData.content, noteData.xr, noteData.yr);
  };

  NoteManager.prototype.newNote = function(noteData) {
    return this.addNote(noteData).textEntry.focus();
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

  NoteManager.prototype.deleteNote = function(nid) {
    this.getNote(nid).destroy();
    return delete this.notes.nid;
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
