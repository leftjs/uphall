path = require('path')

port = 7410
host = 'http://localhost:'
env = process.env.NODE_ENV
if env is 'production'
  port = 80
  host = 'http://121.42.182.77:'

module.exports = {
  port : port
  dbFilePath: path.join(__dirname,'./../database/')
  dbPath: 'mongodb://localhost/myapi'
  secret: 'token secret'
  tokenExpiredTime: 1000*60*60*24*7

  avatar_base: host + port + '/api/images/avatar/'
  window_icon_base: host + port + '/api/images/window_icon/'
  comment_images_base: host  + port + '/api/images/comment_images/'
  food_icon_base: host + port + '/api/images/food_icon/'
}