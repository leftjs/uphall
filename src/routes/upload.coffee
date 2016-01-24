express = require 'express'
router = express.Router()
db = require './../libs/db'

commonBiz = require '../bizs/commonBiz'

uploadBiz = require '../bizs/uploadBiz'



# 用户头像上传api
router.post(
  '/avatar'
  commonBiz.authAndSetUserInfo
  uploadBiz.uploadAvatar
)


router.post(
  '/window/:id'
  commonBiz.authAndSetUserInfo
  uploadBiz.uploadWindowIcon
)

router.post(
  '/comment/:id'
  commonBiz.authAndSetUserInfo
  uploadBiz.uploadCommentImages
)


router.post(
  '/food/:id'
  commonBiz.authAndSetUserInfo
  uploadBiz.uploadFoodIcon
)

module.exports = router




