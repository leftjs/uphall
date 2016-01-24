gulp = require 'gulp'
del = require 'del'
runSequence = require 'run-sequence'
developServer = require 'gulp-develop-server'
notify = require 'gulp-notify'
mocha = require('gulp-mocha')
coffee = require('gulp-coffee')
gutil = require('gulp-util')
exit = require('gulp-exit')

gulp.task 'default',(callback) ->
  runSequence(['clean'],['coffee'],['copyFiles'],['serve','watch','test'],['mochaSequence'],callback)


gulp.task 'test',(callback) ->
  runSequence(['clean'],['coffee'],['copyFiles'],['serve'],['mochaSequenceWillExit'],callback)

gulp.task 'build',(callback) ->
  runSequence(['clean'],['coffee'],['copyFiles'],callback)

gulp.task('coffee', ->
  gulp.src(['./src/**/*.coffee','./**/*.coffee'])
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .pipe(gulp.dest('./dist/'))
  )

gulp.task 'clean',(callback) ->
  del ['./dist/'], callback


gulp.task 'copyFiles', ->
  gulp.src(['./src/*/*.db','./src/**/*.jpg','./deploy'])
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
  del ['./dist/database/'],callback

gulp.task('mocha',->
  gulp.src('./dist/test/**/*.js')
  .pipe(mocha())

)
gulp.task('mochaWillExit',->
  gulp.src('./dist/test/**/*.js')
  .pipe(mocha())
  .pipe(exit())

)


gulp.task('mochaSequence',(callback) ->
  runSequence(['cleanDb'],['coffee'],['mocha'],callback)
)

gulp.task('mochaSequenceWillExit',(callback) ->
  runSequence(['cleanDb'],['coffee'],['mochaWillExit'],callback)
)

gulp.task 'reload', (callback) ->
  runSequence(['copyFiles'],['reload-node'],['mochaSequence'],callback)

gulp.task 'reload-node', ->
  developServer.restart()
  gulp.src('./dist/index.js')
  .pipe(notify('Server restarted...'))
