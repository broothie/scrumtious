exec = require('child_process').exec
fs = require 'fs'

task 'build', 'Continuously builds coffee from `scrumtious/cs` to `scrumtious/static/js`', ->
  try fs.mkdirSync './scrumtious/static/js'
  build = exec 'coffee -cwbo ./scrumtious/static/js ./scrumtious/cs'
  build.stdout.on 'data', (data) -> console.log "build stdout: #{data}"
  build.stderr.on 'data', (data) -> console.log "build stderr: #{data}"

task 'run', 'Runs application', ->
  run = exec 'source .env; gunicorn -b 127.0.0.1:5000 -k gevent -w 1 scrumtious:app'
  run.stdout.on 'data', (data) -> console.log "run stdout #{data}"
  run.stderr.on 'data', (data) -> console.log "run stderr #{data}"
