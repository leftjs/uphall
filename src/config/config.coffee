path = require('path')

port = 7410

module.exports = {
  port : port
  dbFilePath: path.join(__dirname,'./../database/')
  dbPath: 'mongodb://localhost/myapi'
  secret: 'token secret'
  tokenExpiredTime: 1000*60*60*24*7

  avatar_base: 'http://localhost:' + port + '/api/images/avatar/'
  window_icon_base: 'http://localhost:' + port + '/api/images/window_icon/'
  comment_images_base: 'http://localhost:' + port + '/api/images/comment_images/'
  food_icon_base: 'http://localhost:' + port + '/api/images/food_icon/'
}