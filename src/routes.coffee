### routes.coffee ###
# 3rd party imports
router = require('express').Router()

# Index route
router.get '/', (req, res) ->
  res.redirect '/scrumblr'

# Start routes
router.get '/start', (req, res) ->
  res.render 'start'

# Scrumblr route
router.get '/scrumblr', (req, res) ->
  res.render 'scrumblr'

# Export the router that was just made
module.exports = router
