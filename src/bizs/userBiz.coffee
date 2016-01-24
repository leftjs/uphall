jwt = require('jsonwebtoken')

db = require('./../libs/db')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'



# 验证用户是否存在
validateUserExist = (req,res,next) ->
  body = req.body
  return next(commonBiz.customError(400,'请提交完整的用户注册信息')) if not body or not body.username or not body.password
  db.users.findOne({username: req.body.username},(err,user) ->
    return next(err) if err
    return next(commonBiz.customError(400,'用户已注册，无法再次注册')) if user
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
    is_windower: body.is_windower ?= false
    avatar_uri: ''
    score: 0   # 积分系统
  }

  db.users.insert(postData,(err,user) ->
    return next(err) if err
#    console.log(user)
    res.send({id: user._id})
  )

# 登录
login = (req,res,next) ->
  username = req.body.username
  password = md5Util.md5(req.body.password ?= '')
  db.users.findOne({username:username,password:password},(err,user) ->
    return next(err) if err
    return next(commonBiz.customError(400,'用户名或密码错误')) if not user
    token = jwt.sign({id: user._id},config.secret)
    expiredTime = Date.now() + config.tokenExpiredTime
    db.users.update({_id:user._id},{$set: {token:token,expiredTime:expiredTime}},(err,numReplaced) ->
      return next(err) if err
      return next(commonBiz.customError(400,'登录失败，请重试')) if numReplaced is 0
      res.json({token: token,expiredTime:expiredTime})
    )
  )



# 自动登录
autoLogin = (req,res,next) ->
  token = req.body.token
  db.users.findOne({token: token},{expiredTime:{$gt: Date.now()}},(err,user) ->
    return next(err) if err
    return res.json(true) if user
  )




update = (req,res,next) ->
  doing = (req,res,next) ->
    postData = {}
    if req.body.name
      postData.name = req.body.name
    if req.body.password
      postData.password = md5Util.md5(req.body.password)
    if req.body.is_admin isnt undefined
      postData.is_admin = req.body.is_admin
    if req.body.is_windower isnt undefined
      postData.is_windower = req.body.is_windower

    db.users.update({_id: id},{$set:postData},(err,numReplaced) ->
      return next(err) if err
      return next(commonBiz.customError(400,'更新失败,请重试')) if numReplaced is 0
      res.json(true)
    )

  id = req.params['id']
  token = req.header('x-token')
  idInToken = Utils.idFromToken(token)

  if id isnt idInToken
    commonBiz.authIsAdmin(idInToken,() ->
      doing(req,res,next)
    )
#    db.users.findOne({_id: idInToken},(err,user) ->
#      return next(err) if err
#      if user.is_admin
#        doing(req,res,next)
#      else
#        return next(commonBiz.customError(401,'您没有权利这么做'))
#    )
  else
    doing(req,res,next)





module.exports = {
  validateUserExist: validateUserExist
  register: register
  login: login
  autoLogin: autoLogin
  update: update
}