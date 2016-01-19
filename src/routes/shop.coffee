express = require('express')
router = express.Router()


shopBiz = require('./../bizs/shopBiz')
commonBiz = require '../bizs/commonBiz'


# 添加一个窗口
router.post(
  '/add'
  commonBiz.authAndSetUserInfo
  shopBiz.addShop
)


# 获取某一类的窗口
router.get(
  '/all/type/:type'
  shopBiz.getSomeShop
)

# 获取某一个楼的窗口
router.get(
  '/all/floor/:floorId'
)


# 获取所有窗口的信息
router.get(
  '/all'
  shopBiz.getAllShop
)


# 获取某个窗口的信息
router.get(
  '/:shopId'
  shopBiz.getShop
)


#################################################

# 添加一个菜品
router.post('/shop')

# 移除一个菜品
router.delete('/shop/:id')

# 获取所有菜品
router.get('/shop/:shopId/')


module.exports = router