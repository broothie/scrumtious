### routes.coffee ###
# 3rd party imports
router = require('express').Router()

# Index route
router.get '/', (req, res) ->
  res.redirect '/scrumbr'

# Start routes
router.get '/start', (req, res) ->
  res.render 'start'

# Scrumblr route
router.get '/scrumbr', (req, res) ->
  res.render 'scrumbr'

# Export the router that was just made
module.exports = router
