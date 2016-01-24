express = require 'express'
router = express.Router()
db = require './../libs/db'

commonBiz = require '../bizs/commonBiz'

commentBiz = require '../bizs/commentBiz'



# 用户头像上传api
router.post(
  '/:id'
  commonBiz.authAndSetUserInfo
  commentBiz.addCommentToOrder
)



module.exports = router




