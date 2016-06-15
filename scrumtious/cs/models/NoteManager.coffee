# scrumtious/cs/models/NoteManager.coffee becomes:
### scrumtious/static/js/models/NoteManager.js ###

class NoteManager
  notes: {}

  constructor: (@agent, noteDatas) ->
    for nid, noteData of noteDatas
      console.log noteData
      @addNote noteData

  addNote: (noteData) ->
    @notes[noteData.nid] = new Note @agent, noteData.nid, noteData.content, noteData.xr, noteData.yr

  newNote: (noteData) ->
    @addNote(noteData).textEntry.focus()

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
