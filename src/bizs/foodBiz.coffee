db = require('./../libs/db')

config = require('./../config/config')

commonBiz = require './commonBiz'
Utils = require './../utils/Utils'

_ = require 'underscore'

# 添加食物
addFood = (req,res,next) ->
  windowId = req.params['id']
  token = req.headers['x-token']


  db.windows.findOne({_id: windowId}, (err,window) ->
    return next(err) if err
    return next(commonBiz.customError(404,'没有找到该窗口')) if not window
    return next(commonBiz.customError(401,'您没有权利这么做')) if window.author.id isnt Utils.idFromToken(token)

    postData = {
      name: req.body.name ?= '麻婆豆腐'  # 食物名称
      price: req.body.price ?= 2.5    # 食物价格
      number: req.body.price ?= 100 # 食物余量
      is_delete: false
      window_id: windowId
    }
    db.foods.insert(postData,(err,doc) ->
      return next(err) if err
      return res.json({id: doc._id})

    )


  )


module.exports = {
  addFood: addFood
}