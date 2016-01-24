var app, bodyParser, commentRoutes, cookieParser, cors, express, foodRoutes, logger, orderRoutes, path, shopRoutes, uploadRoutes, userRoutes;

express = require('express');

path = require('path');

logger = require('morgan');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

cors = require('cors');

uploadRoutes = require('../routes/upload');

userRoutes = require('../routes/user');

shopRoutes = require('../routes/window');

foodRoutes = require('../routes/food');

orderRoutes = require('../routes/order');

commentRoutes = require('../routes/comment');

app = express();

app.use(logger('dev'));

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(cookieParser());

app.use('/api/images', express["static"](path.join(__dirname, '../images')));

app.use(cors());

app.use('/api/upload', uploadRoutes);

app.use('/api/users', userRoutes);

app.use('/api/windows', shopRoutes);

app.use('/api/foods', foodRoutes);

app.use('/api/orders', orderRoutes);

app.use('/api/comments', commentRoutes);

app.use(function(req, res, next) {
  var err;
  err = new Error('Not Found');
  err.status = 404;
  return next(err);
});

if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    return res.json({
      message: err.message,
      error: err
    });
  });
}

app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  return res.json({
    message: err.message,
    error: {}
  });
});

module.exports = app;
