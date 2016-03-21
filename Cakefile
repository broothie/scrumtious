require 'shortcake'
exec = require('child_process').exec

task 'build', 'Builds coffee', ->
  build = exec 'coffee -co ./ src/'
  build.stdout.on 'data', (data) -> console.log "build stdout: #{data}"
  build.stderr.on 'data', (data) -> console.log "build stderr: #{data}"

task 'start', 'Runs built code', ['build'], ->
  start = exec 'foreman start'
  start.stdout.on 'data', (data) -> console.log "start stdout: #{data}"
  start.stderr.on 'data', (data) -> console.log "start stderr: #{data}"

task 'clean', 'Cleans previously transpiled JS', ->
  clean = exec 'rm ./*.js'
  clean.stdout.on 'data', (data) -> console.log "clean stdout: #{data}"
  clean.stderr.on 'data', (data) -> console.log "clean stderr: #{data}"
