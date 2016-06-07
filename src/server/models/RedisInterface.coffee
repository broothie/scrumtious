# src/server/models/BoardRecord.coffee becomes:
### models/BoardRecord.js ###


class RedisInterface
  ### Schema:
    activeBoards
      "activeBoards" represents a list containing the active boards
    board
      "<boardId>:maxNid" represents a board's max note id
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

  constructor: ->
    redis = require 'redis'
    bluebird = require 'bluebird'
    bluebird.promisifyAll(redis.RedisClient.prototype)
    @mem = redis.createClient process.env.REDISCLOUD_URL

  populateBoard: (boardId, maxNid, notes) ->
    @mem.set "#{boardId}:maxNid", maxNid

    @mem.del "#{boardId}:notes"
    for note in notes
      @mem.sadd "#{boardId}:notes", nid
      @mem.del "#{boardId}:#{nid}"

  addRecord: (boardId) ->
    @mem.sadd 'activeBoards', boardId

  removeRecord: (boardId) ->
    @mem.srem 'activeBoards', boardId

  recordExists: (boardId) ->
    @mem.sismemberAsync 'activeBoards', boardId

  newNote: (boardId, xr, yr) ->
    @mem.get "#{boardId}:maxNid", (err, res) ->
      nid = parseInt res
      @mem.sadd "#{boardId}:notes", nid
      @mem.hmset "#{boardId}:#{nid}", {
        nid: nid
        xr: xr
        yr: yr
        content: ''
      }
      @mem.incr "#{boardId}:maxNid"

  changeNote: (boardId, nid, content) ->
    @mem.hset "#{boardId}:#{nid}", 'content', content

  moveNote: (boardId, nid, xr ,yr) ->
    @mem.hmset "#{boardId}:#{nid}", {
      xr: xr
      yr: yr
    }

  deleteNote: (boardId, nid) ->
    @mem.srem "#{boardId}:notes", nid
    @mem.del "#{boardId}:#{nid}"

  getNote: (boardId, nid) ->
    @mem.hgetallAsync "#{boardId}:#{nid}"

  getNotes: (boardId) ->
    @mem.smembersAsync "#{boardId}:notes"


module.exports = new BoardRecord
