db = require('./../libs/db')

config = require('./../config/config')

commonBiz = require './commonBiz'
Utils = require './../utils/Utils'

_ = require 'underscore'
Q = require 'q'
eventproxy = require 'eventproxy'



addOrder = (req,res,next) ->
  windowId = req.params['id']

  db.windows.findOne({_id: windowId,is_delete: false},(err,window) ->
    return next(err) if err
    return next(commonBiz.customError(404,'窗口未找到')) if not window
    itemsNumber = req.body.length

    ep = new eventproxy()
    ep.fail((err) ->
      return next(err)
    )
    ep.after('found',itemsNumber, (datas) ->
#      console.log(datas)
      trueDatas = _.compact(datas)
      if trueDatas.length isnt 0
        total = 0
        for data in trueDatas
          total += data.price * data.count
        db.orders.insert({
          items:trueDatas
          count:trueDatas.length
          total:total
          status: '预定'
          windowId: windowId
        },(err,result) ->
          return next(err) if err
          return res.json({id: result._id}) if result
        )
      else
        return next(commonBiz.customError(400,'添加订单失败,请检查您的订单'))
    )
    req.body.map((pair) ->
      item = pair.item
      count = pair.count
      db.foods.findOne({_id: item, is_delete: false}, (err,doc) ->
        if doc
          ep.emit('found',{id: doc._id,name: doc.name,count:count,price:doc.price})
        else
          ep.emit('found',null)
      )
    )
  )




getOrder = (req,res,next) ->

  1





module.exports = {
  addOrder: addOrder
  getOrder: getOrder
}


