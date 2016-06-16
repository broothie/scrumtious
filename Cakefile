exec = require('child_process').exec
fs = require 'fs'

# Spin task
task 'spin', 'spins up background tasks', ->
  invoke 'storage'
  invoke 'build'

# Storage tasks
task 'storage', 'runs storage servers', ->
  # invoke.parallel ['storage:mongo', 'storage:redis']
  invoke 'storage:mongo'
  invoke 'storage:redis'

task 'storage:mongo', 'runs mongo', ->
  try fs.mkdirSync '~/databases/mongo/'
  storage = exec 'mongod --dbpath ~/databases/mongo/'
  storage.stdout.on 'data', (data) -> console.log "mongo stdout: #{data}"
  storage.stderr.on 'data', (data) -> console.log "mongo stderr: #{data}"

task 'storage:redis', 'runs redis', ->
  storage = exec 'redis-server'
  storage.stdout.on 'data', (data) -> console.log "redis stdout: #{data}"
  storage.stderr.on 'data', (data) -> console.log "redis stderr: #{data}"

# Build tasks
task 'build', 'build css & js', ->
  invoke 'build:js'
  invoke 'build:css'

task 'build:js', 'builds js', ->
  try fs.mkdirSync './scrumtious/static/js'
  build = exec 'coffee -cwbo ./scrumtious/static/js ./scrumtious/src/coffee'
  build.stdout.on 'data', (data) -> console.log "coffee build stdout: #{data}"
  build.stderr.on 'data', (data) -> console.log "coffee build stderr: #{data}"

task 'build:css', 'builds css', ->
  build = exec 'sass --watch scrumtious/src/sass:scrumtious/static/css'
  build.stdout.on 'data', (data) -> console.log "sass build stdout: #{data}"
  build.stderr.on 'data', (data) -> console.log "sass build stderr: #{data}"
