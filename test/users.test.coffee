request = require('supertest')
#app = require('../src/libs/app') # 代码app
app = require('../dist/libs/app')

# 全局token
adminId = ''
adminToken = ''

customerId = ''
customerToken = ''

shopperId = ''
shopperToken = ''




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
  it('register with a shopper user will success',(done) ->
    request(app)
    .post('/api/users/register')
    .send({username: 'shopper',password: 'shopper',is_shopper: true})
    .expect(200)
    .expect((res) ->
      shopperId = res.body.id
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
  it('login a shopper user to test will success', (done) ->
    request(app)
    .post('/api/users/login')
    .send({username:'shopper',password:'shopper'})
    .expect(200)
    .expect((res) ->
      shopperToken = res.body.token
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
  it('update is_admin with true by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + customerId)
    .set('x-token',customerToken)
    .send({is_admin: true})
    .expect(200)
    .end(done)
  )
  it('update is_admin with false by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + customerId)
    .set('x-token',customerToken)
    .send({is_admin: false})
    .expect(200)
    .end(done)
  )
  it('update is_shoper with false by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + customerId)
    .set('x-token',customerToken)
    .send({is_shopper: true})
    .expect(200)
    .end(done)
  )
  it('update is_shoper with false by one\'s self',(done) ->
    request(app)
    .put('/api/users/' + customerId)
    .set('x-token',customerToken)
    .send({is_shopper: false})
    .expect(200)
    .end(done)
  )
  it('update is_shoper with true by admin',(done) ->
    request(app)
    .put('/api/users/' + customerId)
    .set('x-token',adminToken)
    .send({is_shopper: true})
    .expect(200)
    .end(done)
    )
  )


