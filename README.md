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
   
   * failure: 404（具体错误原因参照返回err中的message，以下401为未授权错误，主要是用户不是当前所允许的用户，或者token未传、400未自定义错误，主要是对应功能操作失败后的返回、404主要为资源未找到错误，大多数场景是需求参数传错或者未传或者是url访问出错，以后各错误类型均如此，在此不再赘述）
   * success: 200 {id: 用户的id}
   
2. 用户登录
   
   description:为用户提供登录的功能
   
   url: /api/users/login
   
   method: POST
   
   params:
   
   * username: [required,string] 用户名
   * password: [required,string] 密码
   
   return:
   
   * failure: 400
   * success:200 {token:登录成功的标志，以后每次访问均要携带以判断用户身份,expiredTime:token的有效期(默认为7天）
   
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
   
   * 400
   * 200 {true}
   
4. 用户信息的获取
   
   description: 获取指定用户的信息
   
   url: /api/users/:id
   
   method: GET 
   
   ​
   
   ​
   
   ​





## License

**MIT**