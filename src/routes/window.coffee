express = require('express')
router = express.Router()


windowBiz = require('./../bizs/windowBiz')
commonBiz = require '../bizs/commonBiz'


# 添加一个窗口
router.post(
  '/addwindow'
  commonBiz.authAndSetUserInfo
  windowBiz.addWindow
)

router.get(
  '/getwindow/:id'
  commonBiz.authAndSetUserInfo
  windowBiz.getWindow
)


router.put(
  '/updatewindow/:id'
  commonBiz.authAndSetUserInfo
  windowBiz.updateWindow
)


router.delete(
  '/deletewindow/:id'
  commonBiz.authAndSetUserInfo
  windowBiz.removeWindow
)



module.exports = router