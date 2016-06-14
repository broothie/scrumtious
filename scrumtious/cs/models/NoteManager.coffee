# scrumtious/cs/models/NoteManager.coffee becomes:
### scrumtious/static/js/models/NoteManager.js ###

class NoteManager
  notes: {}

  constructor: (@agent, noteDatas) ->
    for nid, noteData of noteDatas
      @newNote noteData

  addNote: (note) ->
    @notes[note.nid] = note

  newNote: (noteData) ->
    @addNote new Note @agent, noteData.nid, noteData.content, noteData.xr, noteData.yr

  moveNote: (nid, xr, yr) ->
    @getNote(nid).move xr, yr

  changeNote: (nid, content) ->
    @getNote(nid).change content

  getNote: (nid) ->
    @notes[nid]

  deleteNote: (nid) ->
    @getNote(nid).destroy()
    delete @notes.nid

  data: ->
    note for nid, note of @notes
