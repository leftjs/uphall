
db = require('./../libs/db')
fs = require('fs')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'
commonBiz = require './commonBiz'

_ = require('underscore')
eventproxy = require 'eventproxy'
math = require 'mathjs'


addCommentToOrder = (req,res,next) ->
  orderId = req.params['id']


  # 对商家或者对客户的整体评价
  rating = req.body.rating
  content = req.body.content

  # rates的example: [{food:'foodId',score:5},...]
  rates = req.body.rates

  db.orders.findOne({_id: orderId,is_delete: false},(err,doc) ->
    return next(err) if err
    return next(commonBiz.customError(404,'该订单未找到')) if not doc
    if doc.windowerId is req.userInfo._id
      # 本单商家评价
      if rating
        # TODO 卖家评分的使用场景暂定
        db.comments.insert({
          content: content ?= '这家伙很懒,没有写评价'
          userId: req.userInfo._id
        },(err,comment) ->
          return next(err) if err
          return next(commonBiz.customError(400,'评价失败')) if not comment
          db.orders.update({_id:orderId,is_delete: false},{$set:{windower_evaluated: true,windowerCommentId: comment._id}},(err,numReplaced) ->
            return next(err) if err
            return next(commonBiz.customError(400,'评价失败')) if numReplaced is 0
            res.json({id:comment._id})
          )
        )
      else
        return next(commonBiz.customError(400,'请传入店铺的分值'))
    else if doc.customerId is req.userInfo._id
      # 本单顾客评价
      if rating
        db.comments.insert({
          content: content ?= '这家伙很懒,没有写评价'
          userId: req.userInfo._id
          pics: []
        },(err,comment) ->
          return next(err) if err
          return next(commonBiz.customError(400,'评价失败')) if not comment
          db.orders.update({_id:orderId,is_delete: false},{$set:{customerCommentId:comment._id,customer_evaluated: true}},(err,numReplaced) ->
            return next(err) if err
            return next(commonBiz.customError(400,'评价失败')) if numReplaced is 0
            db.windows.findOne({_id:doc.windowId,is_delete:false},(err,window) ->
              return next(err) if err
              return next(commonBiz.customError(400,'评分的目标窗口未找到')) if not window
              oldScore = window.rate_score
              needToadd = math.round((math.round(rating,1) + math.round(oldScore,1)) / 2,1)
              db.windows.update({_id:doc.windowId,is_delete:false},{$set:{rate_score: needToadd}},(err,numReplaced) ->
                return next(err) if err
                return next(commonBiz.customError(400,'窗口评价失败')) if numReplaced is 0
                if rates && rates.length  > 0
                  ep = new eventproxy()
                  ep.fail((err) ->
                    return next(err)
                  )
                  ep.after('done',rates.length,(datas) ->
                    db.users.update({_id:req.userInfo._id},{$inc:{score:doc.total}},(err,numReplaced) ->
                      return next(err) if err
                      return next(commonBiz.customError(400,'为用户积分失败,请检查')) if numReplaced is 0
                      return res.json({id:comment._id})
                    )
                  )
                  rates.map((pair) ->
                    foodId = pair.food
                    score = pair.score ?= 5.0
                    db.foods.findOne({_id: foodId},(err,food) ->
                      return next(err) if err
                      return next(commonBiz.customError(404, '所需打分的食物没有找到')) if not food
                      newScore = math.round((math.round(food.rating, 1) + math.round(score, 1)) / 2, 1)
                      db.foods.update({_id: foodId}, {$set: {rating: newScore}}, (err, numReplaced) ->
                        return next(err) if err
                        return next(commonBiz.customError(400, '食物评分失败,请重试')) if numReplaced is 0
                        ep.emit('done', null)
                      )
                    )
                  )
                else
                  return next(commonBiz.customError(400,'请传入食物项的分值'))
              )
            )
          )
        )
      else
        return next(commonBiz.customError(400,'请传入店铺分值'))
    else
      # 不是本单用户评价
      return next(commonBiz.customError(401,'您没有权利这么做'))
  )



module.exports = {
  addCommentToOrder: addCommentToOrder
}



