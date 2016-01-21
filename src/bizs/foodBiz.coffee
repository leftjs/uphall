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
      name: req.body.name ?= '爆炒鸡丝'  # 食物名称
      price: req.body.price ?= 5    # 食物价格
      number: req.body.number ?= 100 # 食物余量
      type: req.body.type ?= '小炒' # 食物类型 '饮料' 等等 均可以
      norms: req.body.norms ?= '5分熟' # 规格
      is_breakfast: req.body.is_breakfast ?= true # 属于早餐
      is_lunch: req.body.is_lunch ?= true # 属于中餐
      is_dinner: req.body.is_dinner ?= true # 属于属于晚餐
      window_id: windowId # 所有窗口
      author_id: window.author.id # 所有者
      sale_a_month: 3000 # 月售数量
      is_delete: false # 删除标志位
    }
    db.foods.insert(postData,(err,doc) ->
      return next(err) if err
      return res.json({id: doc._id})

    )
  )

getFood = (req,res,next) ->
  foodId = req.params['id']

  db.foods.findOne({_id: foodId,is_delete: false},(err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404,'该食物未找到')) if not food
    # 去掉删除标志位
    delete food.is_delete
    res.json(food)
  )


updateFood = (req,res,next) ->
  foodId = req.params['id']
  userInfo = req.userInfo

  db.foods.findOne({_id: foodId},(err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404,'该食物未未找到')) if not food
    return next(commonBiz.customError(401,'您没有权利这么做')) if userInfo._id isnt food.author_id

    postData = commonBiz.concatPostData(food,req.body,_.without(_.keys(food),'_id','author_id','window_id'))

    db.foods.update({_id: foodId},{$set: postData},(err,numReplaced) ->
      return next(err) if err
      return next(commonBiz.customError(400,'更新失败')) if numReplaced is 0
      res.json(true)
    )

  )

deleteFood = (req,res,next) ->
  foodId = req.params['id']
  userInfo = req.userInfo

  db.foods.findOne({_id: foodId},(err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404,'该食物未找到')) if not food
    return next(commonBiz.customError(401,'您没有权利这么做')) if userInfo._id isnt food.author_id

    db.foods.update({_id:foodId},{$set:{is_delete:true}},(err,numReplaced) ->
      return next(err) if err
      return next(commonBiz.customError(400,"删除食物失败")) if numReplaced is 0
      return res.json(true)
    )
  )


getAllFoods = (req,res,next) ->
  windowId = req.params['id']

  db.foods.find({window_id: windowId,is_delete: false},(err,array) ->
    return next(err) if err
    return res.json([]) if array.length is 0


    # 去掉删除标志位
    newArray = _.map(array,(doc) ->
      delete doc.is_delete
      return doc
    )
    return res.json(newArray)
  )


module.exports = {
  addFood: addFood
  getFood: getFood
  updateFood: updateFood
  deleteFood: deleteFood
  getAllFoods: getAllFoods

}