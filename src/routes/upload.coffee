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

module.exports = router




