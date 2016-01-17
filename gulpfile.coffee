gulp = require 'gulp'
del = require 'del'
runSequence = require 'run-sequence'
developServer = require 'gulp-develop-server'
notify = require 'gulp-notify'

gulp.task 'default',(callback) ->
  runSequence(['clean'],['copyFiles'],['serve','watch'],callback)

gulp.task 'clean',(callback) ->
  del ['./dist/'], callback


gulp.task 'copyFiles', ->
  gulp.src(['./src/**/*.js','./src/*/*.db'])
  .pipe(gulp.dest('./dist/'))


gulp.task 'serve', ->
  developServer.listen({
    path: './dist/index.js'
  })

gulp.task 'watch', ->
  gulp.watch('./src/**/*.js',['reload'])

gulp.task 'reload', (callback) ->
  runSequence(['copyFiles'],['reload-node'],callback)

gulp.task 'reload-node', ->
  developServer.restart()
  gulp.src('./dist/index.js')
  .pipe(notify('Server restarted...'))
