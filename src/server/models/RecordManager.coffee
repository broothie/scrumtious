# src/server/models/RecordManager.coffee becomes:
### models/RecordManager.js ###


class RecordManager
  constructor: (@mem=require('../server').redis) ->


module.exports = new RecordManager
