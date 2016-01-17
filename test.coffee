obj =
  a: 32
  b: 'asdf'
  fun: ->
    @a + @b

console.log(obj.fun())


arr = [1, 3, 5, 7, 9]

for item in arr
  console.log(item)


console.log(arr.pop()) while arr.length > 0

obj2 = {
  key: 'mykey'
  value: 'myvalue'
  class: 'my class'

}


console.log key + ":" + value for key,value of obj2

do ->
  console.log('xiaoming')


nullString = null
if nullString?
  console.log(nullString)

str = null
str ?= "asdf"
console.log(str)


fun1 = `function () {
    console.log('fun1')
}`

fun1()



try
  `a = adasdf`
catch err
  console.log(err)
finally
  console.log 'finally'