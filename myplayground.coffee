
commonBiz = require './src/bizs/commonBiz'

_ = require 'underscore'

oldData = {
  name: '匿名'
  username:'1232324'
  token: ''
}

newData = {
  name: '匿名aasdf'
  username: 12
  token:'asdfasdf'
}


result = commonBiz.concatPostData(oldData,newData,{'name'})
console.log(result)
