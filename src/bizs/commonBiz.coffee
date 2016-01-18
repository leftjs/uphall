db = require('./../libs/db')



customError = (status,msg) ->
  err = new Error()
  err.status = status
  err.message = msg
  return err

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
      return next(customError(401, '授权失败,请检查你的token'))

  )

module.exports = {
  authAndSetUserInfo: authAndSetUserInfo
  customError: customError
}