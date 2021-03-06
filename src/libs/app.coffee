express = require('express')
path = require('path')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
cors = require('cors')


uploadRoutes = require('../routes/upload')
userRoutes = require('../routes/user')
shopRoutes = require('../routes/window')
foodRoutes = require('../routes/food')
orderRoutes = require('../routes/order')
commentRoutes = require '../routes/comment'

app = express()


# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: false}))
app.use(cookieParser())
#console.log(path.join(__dirname,'../images'))
app.use('/api/images',express.static(path.join(__dirname,'../images')))




app.use(cors())

#app.use('/', routes)
#app.use('/users', users)


# 验证权限
#app.use(commonBiz.validateUserInfo)
app.use('/api/upload', uploadRoutes)
app.use('/api/users', userRoutes)
app.use('/api/windows', shopRoutes)
app.use('/api/foods',foodRoutes)
app.use('/api/orders',orderRoutes)
app.use('/api/comments',commentRoutes)



# catch 404 and forward to error handler
app.use (req, res, next)->
  err = new Error('Not Found')
  err.status = 404
  next(err)


# error handlers

# development error handler
# will print stacktrace
if (app.get('env') is 'development')
  app.use((err, req, res, next) ->
    res.status(err.status || 500)
    res.json({
      message: err.message
      error: err
    })
  )


# production error handler
# no stacktraces leaked to user
app.use((err, req, res, next) ->
  res.status(err.status || 500)
  res.json({
    message: err.message
    error: {}
  })
)


module.exports = app;
