// Generated by CoffeeScript 1.10.0
(function() {
  var coffee, del, developServer, exit, gulp, gutil, mocha, notify, runSequence;

  gulp = require('gulp');

  del = require('del');

  runSequence = require('run-sequence');

  developServer = require('gulp-develop-server');

  notify = require('gulp-notify');

  mocha = require('gulp-mocha');

  coffee = require('gulp-coffee');

  gutil = require('gulp-util');

  exit = require('gulp-exit');

  gulp.task('default', function(callback) {
    return runSequence(['clean'], ['coffee'], ['copyFiles'], ['serve', 'watch', 'test'], ['mochaSequence'], callback);
  });

  gulp.task('travis', function(callback) {
    return runSequence(['clean'], ['coffee'], ['copyFiles'], ['serve'], ['mochaSequenceWillExit'], callback);
  });

  gulp.task('build', function(callback) {
    return runSequence(['clean'], ['coffee'], ['copyFiles'], callback);
  });

  gulp.task('coffee', function() {
    return gulp.src(['./src/**/*.coffee', './**/*.coffee']).pipe(coffee({
      bare: true
    }).on('error', gutil.log)).pipe(gulp.dest('./dist/'));
  });

  gulp.task('clean', function(callback) {
    return del(['./dist/'], callback);
  });

  gulp.task('copyFiles', function() {
    return gulp.src(['./src/*/*.db', './src/**/*.jpg', './deploy']).pipe(gulp.dest('./dist/'));
  });

  gulp.task('serve', function() {
    return developServer.listen({
      path: './dist/index.js'
    });
  });

  gulp.task('watch', function() {
    return gulp.watch(['./src/**/*.js'], ['reload']);
  });

  gulp.task('test', function() {
    return gulp.watch(['./test/**/*.coffee'], ['mochaSequence']);
  });

  gulp.task('cleanDb', function(callback) {
    return del(['./dist/database/'], callback);
  });

  gulp.task('mocha', function() {
    return gulp.src('./dist/test/**/*.js').pipe(mocha());
  });

  gulp.task('mochaWillExit', function() {
    return gulp.src('./dist/test/**/*.js').pipe(mocha()).pipe(exit());
  });

  gulp.task('mochaSequence', function(callback) {
    return runSequence(['cleanDb'], ['coffee'], ['mocha'], callback);
  });

  gulp.task('mochaSequenceWillExit', function(callback) {
    return runSequence(['cleanDb'], ['coffee'], ['mochaWillExit'], callback);
  });

  gulp.task('reload', function(callback) {
    return runSequence(['copyFiles'], ['reload-node'], ['mochaSequence'], callback);
  });

  gulp.task('reload-node', function() {
    developServer.restart();
    return gulp.src('./dist/index.js').pipe(notify('Server restarted...'));
  });

}).call(this);

//# sourceMappingURL=gulpfile.js.map
