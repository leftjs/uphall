express = require('express')
router = express.Router()

orderBiz = require '../bizs/orderBiz'
commonBiz = require '../bizs/commonBiz'


# 注意id为窗口的id
router.post(
  '/:id'
)


module.exports = router