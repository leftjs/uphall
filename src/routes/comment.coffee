express = require 'express'
router = express.Router()
db = require './../libs/db'

commonBiz = require '../bizs/commonBiz'

commentBiz = require '../bizs/commentBiz'



# 用户上传api
router.post(
  '/:id'
  commonBiz.authAndSetUserInfo
  commentBiz.addCommentToOrder
)


# 获取单个评论
router.get(
  '/order/:id'
  commonBiz.authAndSetUserInfo
  commentBiz.getOrder
)

# 获取窗口的所有评价
router.get(
  '/window/:id'
  commonBiz.authAndSetUserInfo
  commentBiz.getWindowComments
)






module.exports = router




