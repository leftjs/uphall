db = require('./../libs/db')

config = require('./../config/config')

commonBiz = require './commonBiz'
Utils = require './../utils/Utils'

_ = require 'underscore'
Q = require 'q'
eventproxy = require 'eventproxy'




# 添加一个订单
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
      console.log(trueDatas)
      if trueDatas.length isnt 0
        total = 0
        for data in trueDatas
          total += data.price * data.count
        db.orders.insert({
          items:trueDatas
          count:trueDatas.length
          total:total
          createTime: Date.now()
          has_received: false  # 食堂阿姨是否接单
          is_cancel: false # 是否取消
          is_delete: false # 是否删除
          rating: 0 # 评分
          has_done: false # 是否是完成状态
          windower_evaluated: false # 卖家已评
          customer_evaluated: false # 买家已评
          windowId: windowId # 窗口的id
          windowerId: window.author.id # 订单所涉及窗口的所有者的id
          customerId: Utils.idFromToken(req.headers['x-token'])
          customerCommentId: ''
          windowerCommentId: ''
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



# 获取一个订单的信息,只能是对应的窗口管理者以及对应的消费者
getOrder = (req,res,next) ->
  orderId = req.params['id']
  db.orders.findOne({_id: orderId, is_delete: false}, (err,order) ->
#    console.log(order)
    return next(err) if err
    return next(commonBiz.customError(404,'请检查该订单是否存在')) if not order
    idInToken = Utils.idFromToken(req.headers['x-token'])
    if idInToken is order.windowerId || idInToken is order.customerId
      delete order.is_delete
      return res.json(order)
    else
      return next(commonBiz.customError(401,'您没有权利这么做'))
  )


updateOrder = (req,res,next) ->
  id = req.params['id']
  db.orders.findOne({_id: id,is_delete:false},(err,order) ->
    return next(err) if err
    return next(commonBiz.customError(404,'请检查该订单是否存在')) if not order
    postData = {}
    idInToken = Utils.idFromToken(req.headers['x-token'])
    if idInToken is order.windowerId
      # 窗口所有者 有接单,完成订单
      postData = commonBiz.concatPostData(order,req.body,['has_received','has_done'])
    else if idInToken is order.customerId
      # 消费者有取消订单
      postData = commonBiz.concatPostData(order,req.body,['is_cancel'])
    else return next(commonBiz.customError(401,'您没有权利这么做'))

    db.orders.update({_id:id,is_delete:false},{$set:postData},(err,numReplaced) ->
      return next(err) if err
      return next(commonBiz.customError(400,'更新失败')) if numReplaced is 0
      return res.json(true)
    )
  )




module.exports = {
  addOrder: addOrder
  getOrder: getOrder
  updateOrder: updateOrder
}


