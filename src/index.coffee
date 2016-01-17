#!/usr/bin/env node

#
#  Module dependencies.
#
app = require('./libs/app')
debug = require('debug')('src:server')

http = require('http')

config = require './config/config'




port = config.port
app.set('port', port)

#/**
# * Create HTTP server.
# */
server = http.createServer(app)


#/**
# * Listen on provided port, on all network interfaces.
# */
server.listen port, ->
  console.log('server is listening on ' + port)
#/**
# * Event listener for HTTP server "error" event.
# */
onError = (error) ->
  if error.syscall isnt 'listen'
    throw error

  bind = typeof port is 'string' ? 'Pipe ' + port  : 'Port ' + port

  #  handle specific listen errors with friendly messages
  switch error.code
    when 'EACCES'
      console.error(bind + ' requires elevated privileges')
      process.exit(1)

    when 'EADDRINUSE'
      console.error(bind + ' is already in use')
      process.exit(1)

    else
      throw error

server.on('error', onError)


#
#  Event listener for HTTP server "listening" event.
#
onListening = ->
  addr = server.address()
  bind = typeof addr is 'string' ? 'pipe ' + addr : 'port ' + addr.port
  debug('Listening on ' + bind)

server.on('listening', onListening)








