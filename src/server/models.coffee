# src/server/models.coffee becomes:
### src/models.js ###


class Sticky
  text: ''
  constructor: (@id, @x, @y) ->


exports.Board = class Board
  maxId: 0
  stickyList: []
  constructor: (@fingerprint, @name, @cleanname) ->

  addSticky: (x, y) ->
    @stickyList.push new Sticky @maxId++, x, y

  removeSticky: (identifier) ->
    if identifier instanceof Sticky
      @stickyList.splice @stickyList.indexOf sticky, 1
    else
      @removeSticky @getSticky identifier

  getSticky: (id) ->
    (sticky for sticky in @stickyList when sticky.id == id)
