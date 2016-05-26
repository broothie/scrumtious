# src/server/models/RecordManager.coffee becomes:
### models/RecordManager.js ###


class RecordManager
  constructor: (@mem=require('../server').redis) ->

  addRecord: (boardId) ->
    @mem.sadd 'activeBoards', boardId

  removeRecord: (boardId) ->
    @mem.srem 'activeBoards', boardId

  recordExists: (boardId) ->
    @mem.sismemberAsync 'activeBoards', boardId

module.exports = new RecordManager
