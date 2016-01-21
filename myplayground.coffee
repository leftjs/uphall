commonBiz = require './src/bizs/commonBiz'

_ = require 'underscore'

HashMap = require('hashmap')


oldData = {
  name: '匿名'
  username: '1232324'
  token: ''
}

newData = {
  name: '匿名aasdf'
  username: 12
  token: 'asdfasdf'
}

array = []


_.map(array,(doc)->
 console.log(doc.name)
)


