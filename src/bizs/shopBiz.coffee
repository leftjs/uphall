db = require('./../libs/db')

config = require('./../config/config')


addShop = (req,res,next) ->
  body = req.body
  postData = {
    shopName:body.shopName ?= '张师傅的摊点'
    floor : body.floor ?= '1'   # 楼层 字符串 注意！
    type: body.type ?= '0' # 贩卖类型 综合 0 ，点餐 1，快餐 2
    author: req.userInfo ?= {} # 窗口持有者
  }

  db.shops.insert(postData, (err,shop) ->
    return next(err) if err
    res.json({msg:'添加成功',id: shop._id})
  )


getShop = (req,res,next) ->
  id = req.params['shopId']
  db.shops.findOne({_id: id}, (err,shop) ->
    return next(err) if err
    res.json(shop)
  )

getAllShop = (req,res,next) ->
  db.shops.find({},(err,docs) ->
    return next(err) if err
    res.json(docs)
  )


getSomeShop = (req,res,next) ->
  type = req.params['type']
  db.shops.find({type:type}, (err,docs) ->
    return next(err) if err
    res.json(docs)
  )

module.exports = {
  addShop:addShop
  getShop:getShop
  getAllShop:getAllShop
  getSomeShop:getSomeShop
}