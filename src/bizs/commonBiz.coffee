db = require('./../libs/db')

_ = require('underscore')

# 自定义错误
customError = (status,msg) ->
  err = new Error()
  err.status = status
  err.message = msg
  return err

authIsAdmin = (id,callback) ->
  db.users.findOne({_id: id},(err,user) ->
    return next(err) if err
    if user.is_admin
      callback(true)
    else
      callback(false)
  )


#  验证并授权用户
authAndSetUserInfo = (req,res,next) ->
  token = req.header('x-token')
  if not token
    return next(customError(401,'未传入token'))
  db.users.findOne({token:token,expiredTime:{$gt: Date.now()}}, (err,user) ->
    return next(err) if err
    if user
      req.userInfo = user
      return next()
    else
      return next(customError(401, 'api授权失败,请检查你的token'))

  )


#  拼接postdata
concatPostData = (oldData,newData,allow=undefined ) ->
  postData = {}
  keys = _.keys(oldData)
  _.each(newData,(value,key,list) ->
    if _.contains(keys,key) && (allow is undefined || _.contains(allow,key))
      postData[key] = value
  )
  return postData



module.exports = {
  authAndSetUserInfo: authAndSetUserInfo
  customError: customError
  authIsAdmin: authIsAdmin
  concatPostData: concatPostData
}