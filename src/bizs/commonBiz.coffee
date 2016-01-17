db = require('./../libs/db')

validateUserInfo =  (req,res,next) ->
  if req.path is '/api/users/login' or  req.path is '/api/users/register'
    return next()
  else
    token = req.header('x-token')
    db.users.findOne({token:token, expiredTime:{$gt: Date.now()}},(err,user) ->
      req.userInfo = user if not err
      if user
        return next()
      else
        return next("未传token或者token出错")
    )

module.exports = {
  validateUserInfo: validateUserInfo
}