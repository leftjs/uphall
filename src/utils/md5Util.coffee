crypto = require('crypto')

md5 = (text) ->
  return crypto.createHash('md5').update(text.toString()).digest('hex')

module.exports = {
  md5: md5
}