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

#### user（用户）

1. 用户注册
   
   url: domain:port/api/users/register
   
   method:POST
   
   params: 
   
   * username: [required]
   * password: [required]
   * ​





## License

**MIT**