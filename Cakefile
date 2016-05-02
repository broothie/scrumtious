require 'shortcake'
fs = require 'fs'
exec = require('child_process').exec

# All stuff
task 'build', 'Builds coffee', ['build:server', 'build:client'], ->
  invoke.parallel ['build:server', 'build:client']

task 'clean', 'Cleans transpiled JS', ->
  invoke.parallel ['clean:server', 'clean:client']


# Server stuff
task 'build:server', 'Builds server JS into root', ->
  build = exec 'coffee -co ./ ./src/server/'
  build.stdout.on 'data', (data) -> console.log "build stdout: #{data}"
  build.stderr.on 'data', (data) -> console.log "build stderr: #{data}"

task 'clean:server', 'Cleans server JS from root', ->
  exec 'rm ./*.js'


# Client stuff
task 'build:client', 'Builds client JS into public/js/', ->
  try fs.mkdirSync './public/js/'
  build = exec 'coffee -bco ./public/js ./src/client/coffee/'
  build.stdout.on 'data', (data) -> console.log "build stdout: #{data}"
  build.stderr.on 'data', (data) -> console.log "build stderr: #{data}"

task 'clean:client', 'Cleans client JS from public/js/', ->
  exec 'rm -rf ./public/js/'
