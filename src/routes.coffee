### routes.coffee ###
# 3rd party imports
router = require('express').Router()

# Index route
router.get '/', (req, res) ->
  res.redirect '/board'

# Start routes
router.get '/start', (req, res) ->
  res.render 'start'

# Scrumblr route
router.get '/board', (req, res) ->
  res.render 'scrumbr'

# Export the router that was just made
module.exports = router
