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



# 更新一个订单的信息,注意消费者和窗口管理者的相应权限,默认无权的属性提交无效,并且不给出提示
router.put(
  '/:id'
  commonBiz.authAndSetUserInfo
  orderBiz.updateOrder
)


module.exports = router