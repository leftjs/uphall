var _, authAndSetUserInfo, authIsAdmin, concatPostData, customError, db;

db = require('./../libs/db');

_ = require('underscore');

customError = function(status, msg) {
  var err;
  err = new Error();
  err.status = status;
  err.message = msg;
  return err;
};

authIsAdmin = function(id, callback) {
  return db.users.findOne({
    _id: id
  }, function(err, user) {
    if (err) {
      return next(err);
    }
    if (user.is_admin) {
      return callback(true);
    } else {
      return callback(false);
    }
  });
};

authAndSetUserInfo = function(req, res, next) {
  var token;
  token = req.header('x-token');
  if (!token) {
    return next(customError(401, '未传入token'));
  }
  return db.users.findOne({
    token: token,
    expiredTime: {
      $gt: Date.now()
    }
  }, function(err, user) {
    if (err) {
      return next(err);
    }
    if (user) {
      req.userInfo = user;
      return next();
    } else {
      return next(customError(401, 'api授权失败,请检查你的token'));
    }
  });
};

concatPostData = function(oldData, newData, allow) {
  var keys, postData;
  if (allow == null) {
    allow = void 0;
  }
  postData = {};
  keys = _.keys(oldData);
  _.each(newData, function(value, key, list) {
    if (_.contains(keys, key) && (allow === void 0 || _.contains(allow, key))) {
      return postData[key] = value;
    }
  });
  return postData;
};

module.exports = {
  authAndSetUserInfo: authAndSetUserInfo,
  customError: customError,
  authIsAdmin: authIsAdmin,
  concatPostData: concatPostData
};
