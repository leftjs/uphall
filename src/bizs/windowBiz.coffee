db = require('./../libs/db')

config = require('./../config/config')

commonBiz = require './commonBiz'
Utils = require './../utils/Utils'

_ = require 'underscore'



# 添加窗口
addWindow = (req,res,next) ->
  body = req.body
  userInfo = req.userInfo
  if not userInfo.is_windower
    return next(commonBiz.customError(400,"您还不是窗口管理者,请先申请认证"))
  postData = {
    windowName: body.windowName ?= '张师傅的窗口' # 窗口名称
    address: body.address ?= '1楼红椅区12号窗'   # 地址
    type: body.type ?= 0 # 贩卖类型 综合 0 ，点餐 1，快餐 2
    shopping_breakfast: body.shopping_breakfast ?= false # 是否卖早餐
    shopping_lunch : body.shopping_lunch ?= false # 是否卖午餐
    shopping_dinner: body.shopping_dinner ?= false # 是否卖晚餐
    description: body.description ?= '一个新兴的势力'  # 窗口描述
    bulletin: body.bulletin ?= '打包免餐盒费,节假日午休' # 窗口公告
    rate_score: 5.0 # 店铺评分
    sale_a_month: 0 # 月售单数
    sale_a_day: 0 # 日售单数
    createDate: Date.now() # 创建时间
    resting: false # 休息中
    is_delete: false # 创建时删除状态必须为假
    author: {
      id: userInfo._id
      name: userInfo.name
    } # 窗口持有者
  }

  db.windows.insert(postData, (err,shop) ->
    return next(err) if err
    res.json({msg:'添加成功',id: shop._id})
  )

# 获取单个窗口
getWindow = (req,res,next) ->
  id = req.params['id']
  db.windows.findOne({_id: id},(err,window) ->
    return next(err) if err
    return res.json(window) if window
    next(commonBiz.customError(404,'未找到此窗口'))
  )


getAllWindows = (req,res,next) ->
  db.windows.find({is_delete: false},(err,array) ->
    return next(err) if err
    if array.length is 0
      return res.json([])
    return res.json(_.map(array, (doc) ->
      delete doc.is_delete
      return doc
    ))
  )


# 更新窗口
updateWindow = (req,res,next) ->
  doing = (req,res,next) ->
    db.windows.findOne({_id:req.params['id']},(err,doc) ->
      # 窗口持有者无法修改
      postData = commonBiz.concatPostData(doc,req.body,_.without(_.keys(doc),'_id','author','rate_score','sale_a_month'))
      db.windows.update({_id: req.params['id']},{$set:postData},(err,repalcedNum) ->
        return next(err) if err
        return next(commonBiz.customError(400,'更新失败,请重新尝试')) if repalcedNum is 0
        res.json(true)
      )
    )

  db.windows.findOne({_id:req.params['id']},(err,doc) ->
    return next(err) if err
    return next(commonBiz.customError(404,'修改失败,请重试')) if not doc
    idInToken = Utils.idFromToken(req.headers['x-token'])

    if doc.author.id isnt idInToken
      commonBiz.authIsAdmin(idInToken,(flag) ->
        if flag
          doing(req,res,next)
        else
          return next(commonBiz.customError(401,'您没有权利这么做'))
      )
    else
      doing(req,res,next)
  )


removeWindow = (req,res,next) ->

  doing = (req,res,next) ->
    db.windows.update({_id: req.params['id']}, {$set:{is_delete: true}}, (err,numReplaced) ->
      return next(err) if err
      return next(commonBiz.customError(400,'删除失败,请重试')) if numReplaced is 0
      res.json(true)
    )

  db.windows.findOne({_id:req.params['id']}, (err,doc) ->
    return next(err) if err
    return next(commonBiz.customError(404,'请确认所传入的id')) if not doc

    idInToken = Utils.idFromToken(req.headers['x-token'])

    if doc.author.id isnt idInToken
      commonBiz.authIsAdmin(idInToken,(flag) ->
        if flag
          doing(req,res,next)
        else
          return next(commonBiz.customError(401,'您没有权限这么做'))
      )
    else
      doing(req,res,next)
  )






module.exports = {
  addWindow: addWindow
  getWindow: getWindow
  updateWindow: updateWindow
  removeWindow: removeWindow
  getAllWindows: getAllWindows
}