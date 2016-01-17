path = require('path')

module.exports = {
  port : 7410
  dbFilePath: path.join(__dirname,'./../database/')
  dbPath: 'mongodb://localhost/myapi'
  secret: 'password key secret'
  tokenExpiredTime: 1000*60*60*24
}