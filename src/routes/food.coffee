express = require('express')
router = express.Router()

foodBiz = require '../bizs/foodBiz'
commonBiz = require '../bizs/commonBiz'


router.post(
  '/:id/addfood'
  commonBiz.authAndSetUserInfo
  foodBiz.addFood
)






module.exports = router