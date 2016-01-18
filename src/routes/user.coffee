express = require('express')
router = express.Router()

userBiz = require './../bizs/userBiz'
commonBiz = require './../bizs/commonBiz'



# 注册用户
router.post(
  '/register'
  userBiz.validateUserExist
  userBiz.register
)

# 用户登录
router.post(
  '/login'
  userBiz.login
)

#用户列表
router.get(
  '/list'
)


# 用户更新
router.put(
  '/:id'
)

# 获取用户信息
router.get(
  '/:id'
)

module.exports = router