jwt = require('jsonwebtoken')

db = require('./../libs/db')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')



# 验证用户是否存在
validateUserExist = (req,res,next) ->
  body = req.body
  return next('请提交完整的用户注册信息') if not body or not body.username or not body.password
  db.users.findOne({username: req.body.username},(err,user) ->
    return next(err) if err
    return next('用户已注册，无法再次注册') if user
    next()
  )



# 注册
register = (req,res,next) ->
  body = req.body
  postData = {
    name: '匿名'
    username: body.username
    password: md5Util.md5(body.password)
    token: ''
    expiredTime: Date.now()
    is_admin: body.is_admin ?= false
    is_shopper: body.is_shopper ?= false
  }

  db.users.insert(postData,(err,user) ->
    return next(err) if err
    res.send({id: user._id})
  )

# 登录
login = (req,res,next) ->
  username = req.body.username
  password = md5Util.md5(req.body.password ?= '')
  db.users.findOne({username:username,password:password},(err,user) ->
    return next(err) if err
    return next('用户名或密码错误') if !user
    token = jwt.sign({username: username},config.secret)
    expiredTime = Date.now() + config.tokenExpiredTime
    db.users.update({_id:user._id},{$set: {token:token,expiredTime:expiredTime}},(err,numReplaced) ->
      return next(err) if err
      return next("登录失败，请重试") if numReplaced is 0
      res.json({token: token,expiredTime:expiredTime})
    )
  )



module.exports = {
  validateUserExist: validateUserExist
  register: register
  login: login
}