express = require('express')
router = express.Router()

userBiz = require './../bizs/userBiz'


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



# 用户更新
router.post(
  '/update/:id'
)


# 获取用户信息
router.get(
  '/:id'
)

module.exports = router