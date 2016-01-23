
db = require('./../libs/db')
fs = require('fs')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
formidable = require 'formidable'
path = require('path')

_ = require('underscore')

uploadAvatar = (req,res,next) ->

  userId = Utils.idFromToken(req.headers['x-token'])
  form = new formidable.IncomingForm()
  form.uploadDir = 'dist/images/avatar/'
  form.keepExtensions = true
  form.encoding = 'utf-8'
  # 头像的最大尺寸为200k
  form.maxFieldsSize = 200* 1024

  form.parse(req,(err,fields,files) ->
    return next(err) if err
    _.mapObject(files,(val,key) ->
      oldPath = val.path
      oldName = path.basename(oldPath)
      dirPath = path.dirname(oldPath)
      newName = oldName.substr(7,oldName.length)
      newPath = dirPath + '/' + newName


      console.log(config.avatar_base)

      fs.rename(oldPath,newPath,(err) ->
        return next(err) if err
#        return res.json(true)
        db.users.update({_id: userId},{$set:{avatar_uri:config.avatar_base + newName}}, (err,numReplaced)->
          return next(err) if err
          return next(commonBiz.customError(400,'上传失败,请重试')) if numReplaced is 0
          return res.end('success')
      )


      )
    )
  )
  # return res.json('hello')

module.exports = {
  uploadAvatar: uploadAvatar
}



