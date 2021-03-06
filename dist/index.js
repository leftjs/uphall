var app, config, debug, http, onError, onListening, port, server;

app = require('./libs/app');

debug = require('debug')('src:server');

http = require('http');

config = require('./config/config');

port = config.port;

app.set('port', port);

server = http.createServer(app);

server.listen(port, function() {
  return console.log('server is listening on ' + port);
});

onError = function(error) {
  var bind;
  if (error.syscall !== 'listen') {
    throw error;
  }
  bind = typeof port === 'string' ? 'Pipe ' + port : 'Port ' + port;
  switch (error.code) {
    case 'EACCES':
      console.error(bind + ' requires elevated privileges');
      return process.exit(1);
    case 'EADDRINUSE':
      console.error(bind + ' is already in use');
      return process.exit(1);
    default:
      throw error;
  }
};

server.on('error', onError);

onListening = function() {
  var addr, bind;
  addr = server.address();
  bind = typeof addr === 'string' ? 'pipe ' + addr : 'port ' + addr.port;
  return debug('Listening on ' + bind);
};

server.on('listening', onListening);
