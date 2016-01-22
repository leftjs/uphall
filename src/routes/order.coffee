express = require('express')
router = express.Router()

orderBiz = require '../bizs/orderBiz'
commonBiz = require '../bizs/commonBiz'


# 注意id为窗口的id
router.post(
  '/:id'
  commonBiz.authAndSetUserInfo
  orderBiz.addOrder
)

# 获取一个订单,只能是该订单的用户及对应的卖家
router.get(
  '/:id'
  commonBiz.authAndSetUserInfo
  orderBiz.getOrder
)



module.exports = router