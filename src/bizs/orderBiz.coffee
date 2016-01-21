db = require('./../libs/db')

config = require('./../config/config')

commonBiz = require './commonBiz'
Utils = require './../utils/Utils'

_ = require 'underscore'

addOrder = (req,res,next) ->
  windowId = req.params['id']

  db.windows.findOne({_id: windowId,is_delete: false})



module.exports = {


}