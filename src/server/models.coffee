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
    sticky = new Sticky @maxId++, x, y
    @stickyList.push sticky
    return sticky

  removeSticky: (identifier) ->
    # TODO: Understand why this is removing multiple stickies
    if typeof identifier is 'number'
      @removeSticky @getSticky identifier
    else
      @stickyList.splice(@stickyList.indexOf(identifier, 1))

  # removeStickyById: (id) ->
  #   @removeSticky @getSticky id

  getSticky: (id) ->
    (sticky for sticky in @stickyList when sticky.id == id)[0]
