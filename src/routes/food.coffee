express = require('express')
router = express.Router()

foodBiz = require '../bizs/foodBiz'
commonBiz = require '../bizs/commonBiz'


router.post(
  '/:id'
  commonBiz.authAndSetUserInfo
  foodBiz.addFood
)

router.get(
  '/:id'
  commonBiz.authAndSetUserInfo
  foodBiz.getFood
)


router.put(
  '/:id'
  commonBiz.authAndSetUserInfo
  foodBiz.updateFood
)


router.delete(
  '/:id'
  commonBiz.authAndSetUserInfo
  foodBiz.deleteFood
)


module.exports = router