commonBiz = require './src/bizs/commonBiz'

_ = require 'underscore'

HashMap = require('hashmap')
Q = require('q')



foo = (result) ->
  console.log(result)
  return result + result



funcs = [foo,foo,foo]
funcs.reduce(
  (prev,current) ->
    return prev.then(current)
  Q('hello')
)