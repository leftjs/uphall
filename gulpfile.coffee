gulp = require 'gulp'
del = require 'del'
runSequence = require 'run-sequence'
developServer = require 'gulp-develop-server'
notify = require 'gulp-notify'
mocha = require('gulp-mocha')
coffee = require('gulp-coffee')
gutil = require('gulp-util')

gulp.task('coffee', ->
  gulp.src('./src/**/*.coffee')
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .pipe(gulp.dest('./dist/'))
  )

gulp.task 'default',(callback) ->
  runSequence(['clean','coffee'],['copyFiles'],['serve','watch','test'],callback)

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
  gulp.watch(['./src/**/*.js'],['reload'])

gulp.task 'test', ->
  gulp.watch(['./test/**/*.coffee'],['mochaSequence'])

gulp.task 'cleanDb',(callback) ->
  del ['./dist/database'],callback

gulp.task('mocha',->
  gulp.src('./test/**/*.js')
  .pipe(mocha())
)

gulp.task('mochaSequence',(callback) ->
  runSequence(['cleanDb'],['mocha'],callback)
)

gulp.task 'reload', (callback) ->
  runSequence(['copyFiles'],['reload-node'],['mochaSequence'],callback)

gulp.task 'reload-node', ->
  developServer.restart()
  gulp.src('./dist/index.js')
  .pipe(notify('Server restarted...'))
