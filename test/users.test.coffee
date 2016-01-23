request = require('supertest')
#app = require('../src/libs/app') # 代码app
app = require('../dist/libs/app')


# 全局token
adminId = ''
adminToken = ''

customerId = ''
customerToken = ''


windowerId = ''
windowerToken = ''




# 注册测试
describe('POST /api/users/register',->
  it('register only with username:admin will failure',(done) ->
    request(app)
    .post('/api/users/register')
    .send({username: 'admin'})
    .expect(400)
    .end(done)
  )
  it('register with only password:admin will failure',(done) ->
    request(app)
    .post('/api/users/register')
    .send({ password: 'admin'})
    .expect(400)
    .end(done)
  )
  it('register with a customer user will success',(done) ->
    request(app)
    .post('/api/users/register')
    .send({username: 'customer',password: 'customer'})
    .expect(200)
    .expect((res) ->
      customerId = res.body.id
    ).end(done)
  )
  it('register with a windower user will success',(done) ->
    request(app)
    .post('/api/users/register')
    .send({username: 'windower',password: 'windower',is_windower: true})
    .expect(200)
    .expect((res) ->
      windowerId = res.body.id
    ).end(done)
  )
  it('register with admin/admin will success',(done) ->
    request(app)
    .post('/api/users/register')
    .send({username: 'admin', password: 'admin',is_admin: true})
    .expect(200)
    .expect((res) ->
      adminId = res.body.id
    )
    .end(done)
  )
  it('register with admin/admin again will failure', (done) ->
    request(app)
    .post('/api/users/register')
    .send({username: 'admin', password: 'admin'})
    .expect(400)
    .end(done)
  )
)

# 登录测试
describe('POST /api/users/login', ->
  it('login with admin/123 will failure',(done) ->
    request(app)
    .post('/api/users/login')
    .send({username:'admin', password:'123'})
    .expect(400)
    .end(done)
  )
  it('login with admin/admin will failure',(done) ->
    request(app)
    .post('/api/users/login')
    .send({username:'admin', password:'admin'})
    .expect(200)
    .expect((res) ->
      adminToken = res.body.token
    ).end(done)
  )
  it('login a customer user to test will success', (done) ->
    request(app)
    .post('/api/users/login')
    .send({username:'customer',password:'customer'})
    .expect(200)
    .expect((res) ->
      customerToken = res.body.token
    ).end(done)
  )
  it('login a windower user to test will success', (done) ->
    request(app)
    .post('/api/users/login')
    .send({username:'windower',password:'windower'})
    .expect(200)
    .expect((res) ->
      windowerToken = res.body.token
    ).end(done)
  )
)







# 自动登录测试
describe('POST /api/users/autologin', ->
  it('auto login with token',(done) ->
    request(app)
    .post('/api/users/autologin')
    .send({token:adminToken})
    .expect(200)
    .expect((res) ->
      throw new Error('autologin failure') if res.body isnt true
    )
    .end(done)
  )
)

# 用户信息更新api测试
describe('PUT /api/users/:id', ->
  it('update name by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + customerId)
    .set('x-token',customerToken)
    .send({name:'张三'})
    .expect(200)
    .end(done)
    )
  it('update password by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + customerId)
    .set('x-token',customerToken)
    .send({password:'123123123'})
    .expect(200)
    .end(done)
    )
  it('update is_admin with false by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + adminId)
    .set('x-token',adminToken)
    .send({is_admin: false})
    .expect(200)
    .end(done)
  )
  it('update is_admin with true by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + adminId)
    .set('x-token',adminToken)
    .send({is_admin: true})
    .expect(200)
    .end(done)
  )

  it('update is_windower with false by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + windowerId)
    .set('x-token',windowerToken)
    .send({is_windower: true})
    .expect(200)
    .end(done)
  )
  it('update is_windower with false by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + windowerId)
    .set('x-token',windowerToken)
    .send({is_windower: false})
    .expect(200)
    .end(done)
  )
  it('update is_windower with true by admin',(done) ->
    request(app)
    .put('/api/users/' + windowerId)
    .set('x-token',adminToken)
    .send({is_windower: true})
    .expect(200)
    .end(done)
    )
  )




# 窗口id
windowId = ''

describe('POST /api/windows/addwindow',->
  it('create a new window  without token',(done) ->
    request(app)
    .post('/api/windows/')
    .expect(401)
    .end(done)
  )
  it('create a new window with fake token',(done) ->
    request(app)
    .post('/api/windows/')
    .set('x-token','fake token')
    .expect(401)
    .end(done)
  )
  it('create a new window by normal user with  token',(done) ->
    request(app)
    .post('/api/windows/')
    .set('x-token',customerToken)
    .expect(400)
    .end(done)
  )
  it('create a new window by windower with token and default params',(done) ->
    request(app)
    .post('/api/windows/')
    .set('x-token',windowerToken)
    .expect(200)
    .expect((res) ->
      windowId = res.body.id
      console.log('windowId:  ' + windowId)

    ).end(done)
  )
  it('create a new window by windower user with fake token and own params',(done) ->
    request(app)
    .post('/api/windows/')
    .set('x-token',windowerToken)
    .send({
      windowName: 'testWindow'
      address: 'testAddress'
      type: '2'
      shopping_breakfast: true
      shopping_lunch: true
      shopping_dinner: true
    })
    .expect(200)
    .expect((res) ->
      windowId = res.body.id
      console.log('windowId:  ' + windowId)
    )
    .end(done)
    )


  )

describe('GET /api/windows/getwindow/:id', ->
  it('get a window with invalidId will failure',(done) ->
    request(app)
    .get('/api/windows/' + 'invalidId')
    .set('x-token',windowerToken)
    .expect(404)
    .end(done)
  )
  it('get a window with validId will success',(done) ->
    request(app)
    .get('/api/windows/' + windowId)
    .set('x-token',windowerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
    )
    .end(done)
  )
)







describe('UPDATE /api/windows/updatewindow/:id', ->

  it('update window without token will failure', (done) ->
    request(app)
    .put('/api/windows/' + windowId)
    .send({windowName:'jason'})
    .expect(401)
    .end(done)
  )
  it('update window by oneself will success', (done) ->
    request(app)
    .put('/api/windows/' + windowId)
    .set('x-token',windowerToken)
    .send({windowName:'jason'})
    .expect(200)
    .end(done)
  )

  it('update window by oneself will success', (done) ->
    request(app)
    .put('/api/windows/' + windowId)
    .set('x-token',adminToken)
    .send({windowName:'zhang',author:{id:'asasdf',name:'hahsdfasdfasdf'}})
    .expect(200)
    .end(done)
  )
  it('validate windownName has been changed',(done) ->
    request(app)
    .get('/api/windows/' + windowId)
    .set('x-token',windowerToken)
    .expect(200)
    .expect((res) ->
      throw new Error() if res.body.windowName isnt 'zhang'
    )
    .end(done)
  )
)



describe('DELETE /api/windows/deletewindow/:id', ->
  it('delete window by oneself',(done) ->
    request(app)
    .delete('/api/windows/' + windowId)
    .set('x-token',windowerToken)
    .expect(200)
    .end(done)
  )
  it('delete window by admin',(done) ->
    request(app)
    .delete('/api/windows/' + windowId)
    .set('x-token',adminToken)
    .expect(200)
    .end(done)
  )
  it('delete window by customer',(done) ->
    request(app)
    .delete('/api/windows/' + windowId)
    .set('x-token',customerToken)
    .expect(401)
    .end(done)
  )
)



describe('GET /api/windows/getallwindows', ->

  it('add a window for test',(done) ->
    request(app)
    .post('/api/windows/')
    .set('x-token',windowerToken)
    .expect(200)
    .end(done)
  )
  it('get all windows',(done) ->
    request(app)
    .get('/api/windows/')
    .set('x-token',customerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
    )
    .end(done)
  )
)


foodId = ''

describe('POST /api/food/:id', ->
  it('add a food to a window with windower',(done) ->
    request(app)
    .post('/api/foods/' + windowId)
    .set('x-token', windowerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
      foodId = res.body.id
    )
    .end(done)
  )
  it('add a food to a window with other user  will failure',(done) ->
    request(app)
    .post('/api/foods/' + windowId )
    .set('x-token', customerToken)
    .expect(401)
    .expect((res) ->
      console.log(res.body)
    )
    .end(done)
  )


)




describe('单个食物的删改查', ->
  it('获取一个是食物的信息',(done) ->
    request(app)
    .get('/api/foods/' + foodId)
    .set('x-token', customerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
    ).end(done)
  )

  it('修改一个食物的信息',(done) ->
    request(app)
    .put('/api/foods/' + foodId)
    .set('x-token', windowerToken)
    .send({
      name:'土豆丝'
      price:4
      number: 23
      is_breakfast: false
      window_id: 'asdf'
      author_id: 'asdf'
    })
    .expect(200)
    .end(done)
  )
  it('获取一个食物的信息',(done) ->
    request(app)
    .get('/api/foods/' + foodId)
    .set('x-token', customerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
    ).end(done)
  )
  it('删除一个食物的信息(不是本人)',(done) ->
    request(app)
    .delete('/api/foods/' + foodId)
    .set('x-token', customerToken)
    .expect(401)
    .end(done)
  )
  it('删除一个食物的信息(是本人)',(done) ->
    request(app)
    .delete('/api/foods/' + foodId)
    .set('x-token', windowerToken)
    .expect(200)
    .end(done)
  )

  it('获取一个食物的信息',(done) ->
    request(app)
    .get('/api/foods/' + foodId)
    .set('x-token', customerToken)
    .expect(404)
    .end(done)
  )
  it('获取某个窗口下的所有食物', (done) ->
    request(app)
    .get('/api/foods/list/' + windowId)
    .set('x-token',customerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
    )
    .end(done)
  )
  it('add a food to a window with windower',(done) ->
    request(app)
    .post('/api/foods/' + windowId)
    .set('x-token', windowerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
#      foodId = res.body.id
    )
    .end(done)
  )
  it('add a food to a window with windower',(done) ->
    request(app)
    .post('/api/foods/' + windowId)
    .set('x-token', windowerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
#      foodId = res.body.id
    )
    .end(done)
  )
  it('add a food to a window with windower',(done) ->
    request(app)
    .post('/api/foods/' + windowId)
    .set('x-token', windowerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
#      foodId = res.body.id
    )
    .end(done)
  )
  it('获取某个窗口下的所有食物', (done) ->
    request(app)
    .get('/api/foods/list/' + windowId)
    .set('x-token',customerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
    )
    .end(done)
  )
)



orderId = ''


describe('测试订单相关',->
  it('添加一个新的窗口',(done) ->
    request(app)
    .post('/api/windows/')
    .set('x-token',windowerToken)
    .expect(200)
    .expect((res) ->
      windowId = res.body.id
    )
    .end(done)
  )
  it('添加一个食物',(done) ->
    request(app)
    .post('/api/foods/' + windowId)
    .set('x-token',windowerToken)
    .expect(200)
    .expect((res) ->
      foodId = res.body.id
    )
    .end(done)
  )
  it('查看一个食物',(done) ->
    request(app)
    .get('/api/foods/' + foodId)
    .set('x-token',customerToken)
    .expect(200)
    .expect((res) ->
      console.log(res.body)
    ).end(done)
  )
  it('添加一个订单',(done) ->
    request(app)
    .post('/api/orders/' + windowId)
    .set('x-token',customerToken)
    .send([
      {
        item:foodId
        count: 5
      }
      {
        item:123
        count:4
      }
    ])
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
      orderId = res.body.id
    )
    .end(done)
  )
  it('添加一个无效的订单',(done) ->
    request(app)
    .post('/api/orders/' + windowId)
    .set('x-token',customerToken)
    .send([
      {
        item:1233
        count: 5
      }
      {
        item:123
        count:4
      }
    ])
    .expect(400)
    .end(done)
  )
  it('获取一个订单信息from other will failure',(done) ->
    request(app)
    .get('/api/orders/' + orderId)
    .set('x-token',adminToken)
    .expect(401)
    .end(done)
  )
  it('获取一个订单信息from customer will success',(done) ->
    request(app)
    .get('/api/orders/' + orderId)
    .set('x-token',customerToken)
    .expect(200)
    .expect((res) ->
#      console.log(res.body)
    )
    .end(done)
  )
  it('获取一个订单信息from windower will success',(done) ->
    request(app)
    .get('/api/orders/' + orderId)
    .set('x-token',windowerToken)
    .expect(200)
    .expect((res) ->
      console.log(res.body)
    )
    .end(done)
  )
  it('更新一个订单的信息 from other will failure',(done) ->
    request(app)
    .put('/api/orders/' + orderId)
    .set('x-token', adminToken)
    .send({
      has_done: true
      is_cancel: true
      has_received: true
      windower_evaluated: true
      customer_evaluated: true
    })
    .expect(401)
    .end(done)
  )
  it('更新一个订单的信息 from customer',(done) ->
    request(app)
    .put('/api/orders/' + orderId)
    .set('x-token', customerToken)
    .send({
      has_done: true
      is_cancel: true
      has_received: true
      windower_evaluated: true
      customer_evaluated: true
    })
    .expect(200)
    .end(done)
  )
  it('更新一个订单的信息 from windower',(done) ->
    request(app)
    .put('/api/orders/' + orderId)
    .set('x-token', windowerToken)
    .send({
      has_done: true
      is_cancel: false
      has_received: true
      windower_evaluated: true
      customer_evaluated: false
    })
    .expect(200)
    .end(done)
  )
  it('获取一个订单信息from windower will success',(done) ->
    request(app)
    .get('/api/orders/' + orderId)
    .set('x-token',windowerToken)
    .expect(200)
    .expect((res) ->
      console.log(res.body)
    )
    .end(done)
  )
  it('上传一个头像',(done) ->
    request(app)
    .post('/api/upload/avatar')
    .set('x-token',customerToken)
    .attach('avatar','/Users/jason/Desktop/dog.jpg','dog.jpg')
#    .attach('avatar1','/Users/jason/Desktop/google.png','user.png')
    .expect(200)
    .expect((res) ->
      console.log(res.text)
    )
    .end(done)
  )


)


















