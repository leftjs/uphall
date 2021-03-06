var Utils, _, autoLogin, commonBiz, config, db, getUser, jwt, login, md5Util, register, update, validateUserExist;

jwt = require('jsonwebtoken');

db = require('./../libs/db');

config = require('./../config/config');

md5Util = require('./../utils/md5Util');

Utils = require('./../utils/Utils');

commonBiz = require('./commonBiz');

_ = require('underscore');

validateUserExist = function(req, res, next) {
  var body;
  body = req.body;
  if (!body || !body.username || !body.password) {
    return next(commonBiz.customError(400, '请提交完整的用户注册信息'));
  }
  return db.users.findOne({
    username: req.body.username
  }, function(err, user) {
    if (err) {
      return next(err);
    }
    if (user) {
      return next(commonBiz.customError(400, '用户已注册，无法再次注册'));
    }
    return next();
  });
};

register = function(req, res, next) {
  var body, postData;
  body = req.body;
  postData = {
    name: '匿名',
    username: body.username,
    password: md5Util.md5(body.password),
    token: '',
    expiredTime: Date.now(),
    is_admin: body.is_admin != null ? body.is_admin : body.is_admin = false,
    is_windower: body.is_windower != null ? body.is_windower : body.is_windower = false,
    avatar_uri: '',
    score: 0
  };
  return db.users.insert(postData, function(err, user) {
    if (err) {
      return next(err);
    }
    return res.send({
      id: user._id
    });
  });
};

login = function(req, res, next) {
  var base, password, username;
  username = req.body.username;
  password = md5Util.md5((base = req.body).password != null ? base.password : base.password = '');
  return db.users.findOne({
    username: username,
    password: password
  }, function(err, user) {
    var expiredTime, token;
    if (err) {
      return next(err);
    }
    if (!user) {
      return next(commonBiz.customError(400, '用户名或密码错误'));
    }
    token = jwt.sign({
      id: user._id
    }, config.secret);
    expiredTime = Date.now() + config.tokenExpiredTime;
    return db.users.update({
      _id: user._id
    }, {
      $set: {
        token: token,
        expiredTime: expiredTime
      }
    }, function(err, numReplaced) {
      if (err) {
        return next(err);
      }
      if (numReplaced === 0) {
        return next(commonBiz.customError(400, '登录失败，请重试'));
      }
      return res.json({
        token: token,
        expiredTime: expiredTime
      });
    });
  });
};

autoLogin = function(req, res, next) {
  var token;
  token = req.body.token;
  return db.users.findOne({
    token: token
  }, {
    expiredTime: {
      $gt: Date.now()
    }
  }, function(err, user) {
    if (err) {
      return next(err);
    }
    if (user) {
      return res.json(true);
    }
  });
};

update = function(req, res, next) {
  var doing, id, idInToken, token;
  doing = function(req, res, next) {
    var postData;
    postData = {};
    if (req.body.name) {
      postData.name = req.body.name;
    }
    if (req.body.password) {
      postData.password = md5Util.md5(req.body.password);
    }
    if (req.body.is_admin !== void 0) {
      postData.is_admin = req.body.is_admin;
    }
    if (req.body.is_windower !== void 0) {
      postData.is_windower = req.body.is_windower;
    }
    return db.users.update({
      _id: id
    }, {
      $set: postData
    }, function(err, numReplaced) {
      if (err) {
        return next(err);
      }
      if (numReplaced === 0) {
        return next(commonBiz.customError(400, '更新失败,请重试'));
      }
      return res.json(true);
    });
  };
  id = req.params['id'];
  token = req.header('x-token');
  idInToken = Utils.idFromToken(token);
  if (id !== idInToken) {
    return commonBiz.authIsAdmin(idInToken, function() {
      return doing(req, res, next);
    });
  } else {
    return doing(req, res, next);
  }
};

getUser = function(req, res, next) {
  return db.users.findOne({
    _id: req.params['id']
  }, function(err, user) {
    var allowToShow, field, i, len, ref;
    if (err) {
      return next(err);
    }
    if (!user) {
      return next(commonBiz.customError(404, '未找到该用户'));
    }
    allowToShow = ['name', 'is_windower', 'avatar_uri', 'score'];
    ref = _.difference(_.keys(user), allowToShow);
    for (i = 0, len = ref.length; i < len; i++) {
      field = ref[i];
      delete user[field];
    }
    return res.json(user);
  });
};

module.exports = {
  validateUserExist: validateUserExist,
  register: register,
  login: login,
  autoLogin: autoLogin,
  update: update,
  getUser: getUser
};
