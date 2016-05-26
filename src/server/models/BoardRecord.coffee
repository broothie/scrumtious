# src/server/models/BoardRecord.coffee becomes:
### models/BoardRecord.js ###


module.exports =
class BoardRecord
  ### Schema:
    activeBoards
      "activeBoards" represents a list containing the active boards
    board
      "<boardId>" represents a dict containing the following:
        - boardId: board id
        - maxNid: board's max note id
      "<boardId>:notes" represents a list containing nids
      "<boardId>:clients" represents a list of active client hashes

    note
      - a note is always contained in a board, so it is keyed initially with a
        board id
      "<boardId>:<nid>" represents a dict containing the following:
        - nid: note id
        - xn: normalized x position
        - yn: normalized y position
        - content: note's text content
  ###

  constructor: (@mem=require('../server').redis, @boardId, maxNid, notes) ->
    @mem.set "#{@boardId}:maxNid", maxNid

    for note in notes
      @mem.sadd "#{@boardId}:notes", note.nid
      @mem.hmset "#{@boardId}:#{note.nid}", note

  newSticky: (xr, yr) ->
    @mem.get "#{@boardId}:maxNid", (err, res) ->
      nid = parseInt res
      @mem.sadd "#{@boardId}:notes", nid
      @mem.hmset "#{@boardId}:#{nid}", {
        nid: nid
        xr: xr
        yr: yr
        content: ''
      }
      @mem.incr "#{@boardId}:maxNid"

  changeSticky: (nid, content) ->
    @mem.hset "#{@boardId}:#{nid}", 'content', content

  moveSticky: (nid, xr ,yr) ->
    @mem.hmset "#{@boardId}:#{nid}", {
      xr: xr
      yr: yr
    }

  deleteSticky: (nid) ->
    @mem.srem "#{@boardId}:notes", nid
    @mem.hdel "#{@boardId}:#{nid}"

  getSticky: (nid) ->
    @mem.hgetallAsync "#{@boardId}:#{nid}"

  getNotes: ->
    @mem.smembersAsync "#{@boardId}:notes"
