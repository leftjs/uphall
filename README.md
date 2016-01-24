[![Build Status](https://travis-ci.org/leftjs/uphall.svg?branch=master)](https://travis-ci.org/leftjs/uphall)

# uphall

## The Server for UpHall (尚食堂)

> uphall is a simple app of dinner management ,and this repo is the server of the app, it can make cook(or worker for hall) to publish the infos of  foods ,and people want to have a meal in hall can order the food that she/he want to eat refrain from the long queue. Read the restful api references for more details



## To Contribute

### init first:

``` bash
$ git clone git@github.com:leftjs/uphall.git
$ cd uphall/
$ npm install -g gulp
$ npm install 
$ gulp build (for test)
$ gulp (for serve)
```

## RESTful API References (v1)

**访问处login/register两个api外的api均需要在headers中传入'x-token'以判断用户身份，不传一律拒绝操作，返回401

#### user（用户）

1. 用户注册
   
   description: 为用户提供注册功能
   
   url: /api/users/register
   
   method:POST
   
   params: 
   
   * username: [required,unique,string] 用户名
   * password: [required,string] 密码
   * is_admin: [optional,boolean,default=false] 判断用户是否是管理员的标志位，慎传属性，管理员具有最高权限
   * is_windower: [optional,boolean,default=false] 判断用户是否是窗口服务员的标志位
   
   return:
   
   * 404（具体错误原因参照返回err中的message，以下401为未授权错误，主要是用户不是当前所允许的用户，或者token未传、400未自定义错误，主要是对应功能操作失败后的返回、404主要为资源未找到错误，大多数场景是需求参数传错或者未传或者是url访问出错，500为服务器错误，请将错误原因issues，以便及时修正，以后各错误类型均如此，在此不再赘述）
   * 200 {id: 用户的id}
   
2. 用户登录
   
   description:为用户提供登录的功能
   
   url: /api/users/login
   
   method: POST
   
   params:
   
   * username: [required,string] 用户名
   * password: [required,string] 密码
   
   return:
   
   * 400
   * 200 {token:登录成功的标志，以后每次访问均要携带以判断用户身份,expiredTime:token的有效期(默认为7天）
   
3. 更新用户信息
   
   description: 提供用户信息更新的api
   
   url: /api/users/:id
   
   method:PUT
   
   headers:
   
   * x-token: [required] !!! 用户token  该参数每次必传，以下不再赘述
   
   params:
   
   * id:[required,query,string] 需要更新的用户的id
   * name: [optional,string] 用户昵称
   * password: [optional,string] 用户新密码
   * is_admin:[optional,boolean] 提升为管理员
   * is_windower:[optional,boolean] 提升为窗口服务员
   
   return:
   
   * 400/404
   * 200 {true}
   
4. 用户信息的获取
   
   description: 获取指定用户的信息
   
   url: /api/users/:id
   
   method: GET 
   
   params:
   
   * id:[required,query] 用户的id
   
   return
   
   * 404
   * 200 {name:昵称,is_windower:是否是窗口服务员，avatar_uri:头像链接，score:积分}

#### 窗口（window)

1. 添加一个窗口
   
   description: 添加一个窗口，未传的属性用默认值填充
   
   url:/api/windows/
   
   method: POST
   
   params:
   
   * windowName:[optional,string] 窗口名称
   * address: [optional,string] 地址(example:1楼红椅区12号窗)
   * type:[optional,string]贩卖类型( 综合、点餐、快餐等等）
   * shopping_breakfast: [optional,boolean] 是否卖早饭
   * shopping_lunch: [optional,boolean] 是否卖中饭
   * shopping_dinner: [optional,boolean] 是否卖晚饭
   * description: [optional,string] 窗口描述
   * bulletin: [optional,string] 窗口公告
   * promotion: [optional,string] 优惠信息
   
   return:
   
   * 404
   * 200 {msg:'添加成功',id: 商店的id}
   
2. 获取一个窗口
   
   description: 获取指定窗口信息
   
   url: /api/windows/:id
   
   method:GET
   
   params:
   
   * id: [required,query] 窗口id
   
   return:
   
   * 404 
   * 200 {window: 窗口信息（属性过多，不再赘述）}
   
3. 更新一个窗口
   
   description:更新指定窗口信息，当前用户必须是管理员身份或者窗口所有者
   
   url: /api/windows/:id
   
   method:PUT
   
   params: 
   
   * windowName:[optional,string] 窗口名称
   * address: [optional,string] 地址(example:1楼红椅区12号窗)
   * type:[optional,string]贩卖类型( 综合、点餐、快餐等等）
   * shopping_breakfast: [optional,boolean] 是否卖早饭
   * shopping_lunch: [optional,boolean] 是否卖中饭
   * shopping_dinner: [optional,boolean] 是否卖晚饭
   * description: [optional,string] 窗口描述
   * bulletin: [optional,string] 窗口公告
   * promotion: [optional,string] 优惠信息
   * resting: [optional,boolean] 是否休息中
   * icon:[optional,string] 窗口图标
   
   return:
   
   * 404/401/400
   * 200 {true}
   
4. 删除一个窗口
   
   description:删除指定id的窗口，当前用户必须是管理员或者窗口所有者
   
   url: /api/windows/:id
   
   method: DELETE
   
   return:
   
   * 400/404/401
   * 200 {true}
   
5. 获取所有窗口
   
   description: 获得数据库中所有窗口的信息
   
   url: /api/windows/
   
   method: GET
   
   return:
   
   * 404 
   * 200 [{windowObj},{windowObj},...]
   
6. 获取某个条件下的所有窗口
   
   description: 传入指定的query param，返回符合条件的窗口
   
   url: /api/windows/conditions
   
   method: POST
   
   params:
   
   * type:[optional,string] 窗口类型，没有采用枚举，类型字符串可以自由发挥，但需要注意的是匹配，匹配，匹配！！！
   * shopping_breakfast:[optional,boolean] 
   * shopping_lunch: [optional,boolean]
   * shopping_dinner:[optional,boolean]
   * resting: [optional,boolean]
   
   return:
   
   * 404
   * 200  [{windowObj},{windowObj},...]

#### 食物（food）

1. 添加一个食物
   
   description: 添加一个食物到指定的窗口
   
   url: /api/foods/:id
   
   method:POST
   
   params:
   
   * name:[optional,string] 食物名称
   * price: [optional,number] 食物价格
   * number:[optional,number] 食物的余量
   * type:[optional,string] 食物的类型 如：小炒，饮料等等，未用枚举，自己控制，记得匹配！！！！
   * norms: [optional,string] 食物的规格 如: 五分熟 ，超辣 等等 未用枚举，自己控制，记得匹配！！！！
   * is_breakfast:[optional,boolean]  属于早餐
   * is_lunch: [otpional,boolean] 属于中餐
   * is_dinner: [optional,boolean] 属于晚餐
   
   return:
   
   * 404/401
   * 200 {id:食物id}
   
2. 获取一个食物
   
   description: 通过食物id获得指定食物信息
   
   url: /api/foods/:id
   
   method:GET
   
   params:
   
   * id: [required,query] 食物id
   
   return:
   
   * 404
   * 200 {foodObj}
   
3. 更新一个食物
   
   description: 更新一个食物，允许参数为新增一个food时的参数
   
   url: /api/foods/:id
   
   method:PUT
   
   params:
   
   * name:[optional,string] 食物名称
   * price: [optional,number] 食物价格
   * number:[optional,number] 食物的余量
   * type:[optional,string] 食物的类型 如：小炒，饮料等等，未用枚举，自己控制，记得匹配！！！！
   * norms: [optional,string] 食物的规格 如: 五分熟 ，超辣 等等 未用枚举，自己控制，记得匹配！！！！
   * is_breakfast:[optional,boolean]  属于早餐
   * is_lunch: [otpional,boolean] 属于中餐
   * is_dinner: [optional,boolean] 属于晚餐
   * icon: [optional,string] 图片url
   
   return:
   
   * 404/401
   * 200 {id: 食物id}
   
4. 删除一个食物
   
   description: 删除指定食物的记录，注意权限问题，只有窗口所有者能删除自己的food
   
   url: /api/foods/:id
   
   method:DELETE
   
   params:
   
   * id: [required,query] 食物id
   
   return:
   
   * 404/401/400
   * 200 {true}
   
5. 获取某个窗口的所有食物
   
   description: 根据传入的窗口id，获取该窗口的所有食物
   
   url: /api/foods/list/:id
   
   method:GET
   
   params:
   
   * id: [required,query] 窗口id
   
   return:
   
   * 404
   * 200 [{foodObj},{foodObj},...]

#### 订单（order）

1. 添加一个订单
   
   description: 添加订单，需要指定窗口id
   
   url: /api/orders/:id
   
   method:POST
   
   params:
   
   * id:[required,query] 订单id
   * [{item:foodId1,count:5},{item:foodId2,count:3},…]:[required,array] 传入object数组，其中item的值为食品的id，count为购买的数量
   
   return
   
   * 404/401/400
   * 200 {id:订单号}
   
2. 获取一个订单
   
   url: /api/orders/:id
   
   method:GET
   
3. 更新一个订单
   
   url: /api/orders/:id
   
   method:PUT

   



## License

**MIT**