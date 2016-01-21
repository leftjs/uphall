express = require('express')
router = express.Router()

foodBiz = require '../bizs/foodBiz'
commonBiz = require '../bizs/commonBiz'



# 注意是窗口的id
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

# 获取某个窗口的所有食物
router.get(
  '/list/:id'
  commonBiz.authAndSetUserInfo
  foodBiz.getAllFoods
)


module.exports = router