jwt = require('jsonwebtoken')
config = require('./../config/config')

idFromToken = (token) ->
  decode = jwt.verify(token, config.secret);
  return decode.id


module.exports = {
  idFromToken: idFromToken
}