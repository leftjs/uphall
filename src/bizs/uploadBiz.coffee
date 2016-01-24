
db = require('./../libs/db')
fs = require('fs')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
formidable = require 'formidable'
path = require('path')

eventproxy = require('eventproxy')

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

    ep = new eventproxy()
    ep.fail((err) ->
      return next(err)
    )
    ep.after('done',_.keys(files).length,(datas) ->
#        console.log('12312312312312')
      res.end('success')
    )
    _.mapObject(files,(val,key) ->
      oldPath = val.path
      oldName = path.basename(oldPath)
      dirPath = path.dirname(oldPath)
      newName = oldName.substr(7,oldName.length)
      newPath = dirPath + '/' + newName

      fs.rename(oldPath,newPath,(err) ->
        return ep.emit('error', err) if err
#        return res.json(true)
        db.users.update({_id: userId},{$set:{avatar_uri:config.avatar_base + newName}}, (err,numReplaced)->
          return ep.emit('error', err) if err
          return ep.emit('error',commonBiz.customError(400,'上传失败,请重试')) if numReplaced is 0
          return ep.emit('done',null)
      )
      )
    )
  )




uploadWindowIcon = (req,res,next) ->

  windowId = req.params['id']
  userId = Utils.idFromToken(req.headers['x-token'])

  db.windows.findOne({_id:windowId},(err,window) ->
    return next(err) if err
    return next(commonBiz.customError(404,'当前窗口不存在')) if not window
    return next(commonBiz.customError(401,'您没有权利这么做')) if window.author.id isnt userId
    form = new formidable.IncomingForm()
    form.uploadDir = 'dist/images/window_icon/'
    form.keepExtensions = true
    form.encoding = 'utf-8'
# 窗口icon的最大尺寸为200k
    form.maxFieldsSize = 200 * 1024

    form.parse(req,(err,fields,files) ->
      return next(err) if err
      ep = new eventproxy()
      ep.fail((err) ->
        return next(err)
      )
      ep.after('done',_.keys(files).length,(datas) ->
#        console.log('12312312312312')
        res.end('success')
      )
      _.mapObject(files,(val,key) ->
        oldPath = val.path
        oldName = path.basename(oldPath)
        dirPath = path.dirname(oldPath)
        newName = oldName.substr(7,oldName.length)
        newPath = dirPath + '/' + newName

        fs.rename(oldPath,newPath,(err) ->
          return ep.emit('error', err) if err
          #        return res.json(true)
          iconUri = config.window_icon_base + newName
          db.windows.update({_id: windowId},{$set:{icon:iconUri}}, (err,numReplaced)->
            return ep.emit('error',err) if err
            return ep.emit('error',commonBiz.customError(400,'上传失败,请重试')) if numReplaced is 0
            return ep.emit('done',null)
          )
        )
      )
    )
  )


uploadFoodIcon = (req,res,next) ->

  foodId = req.params['id']
  userId = Utils.idFromToken(req.headers['x-token'])

  db.foods.findOne({_id:foodId},(err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404,'当前食物不存在')) if not food
    return next(commonBiz.customError(401,'您没有权利这么做')) if food.author_id isnt userId
    form = new formidable.IncomingForm()
    form.uploadDir = 'dist/images/food_icon/'
    form.keepExtensions = true
    form.encoding = 'utf-8'
# 窗口icon的最大尺寸为200k
    form.maxFieldsSize = 200 * 1024

    form.parse(req,(err,fields,files) ->
      return next(err) if err
      ep = new eventproxy()
      ep.fail((err) ->
        return next(err)
      )
      ep.after('done',_.keys(files).length,(datas) ->
        res.end('success')
      )
      _.mapObject(files,(val,key) ->
        oldPath = val.path
        oldName = path.basename(oldPath)
        dirPath = path.dirname(oldPath)
        newName = oldName.substr(7,oldName.length)
        newPath = dirPath + '/' + newName

        fs.rename(oldPath,newPath,(err) ->
          return ep.emit('error', err) if err
          #        return res.json(true)
          iconUri = config.food_icon_base + newName
          db.foods.update({_id: foodId},{$set:{icon:iconUri}}, (err,numReplaced)->
            return ep.emit('error',err) if err
            return ep.emit('error',commonBiz.customError(400,'上传失败,请重试')) if numReplaced is 0
            return ep.emit('done',null)
          )
        )
      )
    )
  )


uploadCommentImages = (req,res,next) ->
  commentId = req.params['id']
  userId = Utils.idFromToken(req.headers['x-token'])
  db.comments.findOne({_id: commentId},(err,comment) ->
    return next(err) if err
    return next(commonBiz.customError(404,'该评论不存在')) if not comment
    return next(commonBiz.customError(401,'您没有权利这么做')) if comment.userId isnt userId
    form = new formidable.IncomingForm()
    form.uploadDir = 'dist/images/comment_images/'
    form.keepExtensions = true
    form.encoding = 'utf-8'
# 头像的最大尺寸为200k
    form.maxFieldsSize = 1024 * 1024

    form.parse(req,(err,fields,files) ->
      return next(err) if err

      ep = new eventproxy()
      ep.fail((err) ->
        return next(err)
      )
      console.log(_.keys(files).length)
      ep.after('done',_.keys(files).length,(datas) ->
#        console.log('12312312312312')
        res.end('success')
      )
      _.mapObject(files,(val,key) ->
        oldPath = val.path
        oldName = path.basename(oldPath)
        dirPath = path.dirname(oldPath)
        newName = oldName.substr(7,oldName.length)
        newPath = dirPath + '/' + newName
        fs.rename(oldPath,newPath,(err) ->
          return ep.emit('error',err) if err
          imgUri = config.comment_images_base + newName
          db.comments.update({_id: commentId},{$push:{pics:imgUri}}, (err,numReplaced)->
            return ep.emit('error',err) if err
            return ep.emit('error',commonBiz.customError(400,'上传失败,请重试')) if numReplaced is 0
            return ep.emit('done',null)
          )
        )
      )
    )
  )


  # return res.json('hello')

module.exports = {
  uploadAvatar: uploadAvatar
  uploadWindowIcon:uploadWindowIcon
  uploadCommentImages:uploadCommentImages
  uploadFoodIcon:uploadFoodIcon
}



