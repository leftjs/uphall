express = require('express')
router = express.Router()


windowBiz = require('./../bizs/windowBiz')
commonBiz = require '../bizs/commonBiz'


# 添加一个窗口
router.post(
  '/'
  commonBiz.authAndSetUserInfo
  windowBiz.addWindow
)

router.get(
  '/:id'
  commonBiz.authAndSetUserInfo
  windowBiz.getWindow
)


router.put(
  '/:id'
  commonBiz.authAndSetUserInfo
  windowBiz.updateWindow
)


router.delete(
  '/:id'
  commonBiz.authAndSetUserInfo
  windowBiz.removeWindow
)

router.get(
  '/'
  commonBiz.authAndSetUserInfo
  windowBiz.getAllWindows
)

router.post(
  '/conditions'
  commonBiz.authAndSetUserInfo
  windowBiz.getWindowsByConditions
)




module.exports = router