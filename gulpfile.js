var gulp = require('gulp');
var $ = require('gulp-load-plugins')();
var browserSync = require('browser-sync');

var paths = {
  scripts: [
    'www/js/controllers.coffee',
    'www/js/services.coffee',
    'www/js/app.coffee',
    'www/js/*.coffee',
    'www/js/*/**.coffee'
  ]
};

///////////////////
// build
///////////////////
gulp.task('build', ['firebase', 'onsen', 'scripts']);

///////////////////
// onsen
///////////////////
gulp.task('onsen', function() {
  return gulp.src([
    'bower_components/onsenui/build/*/**'
  ]).pipe(gulp.dest('www/lib/onsen'));
});

////////////////////
// firebase + angularfire
////////////////////
gulp.task('firebase', function() {
  return gulp.src([
    'bower_components/angular/angular.js',
    'bower_components/angular-animate/angular-animate.js',
    'bower_components/angularfire/dist/angularfire.js',
    'bower_components/firebase/firebase.js'
  ]).pipe(gulp.dest('www/lib'));
});

////////////////////
// scripts
////////////////////
gulp.task('scripts', function() {
  return gulp.src(paths.scripts)
    .pipe($.sourcemaps.init())
    .pipe($.coffee())
    .pipe($.uglify())
    .pipe($.concat('all.min.js'))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest('www/js'));
});

////////////////////
// serve
////////////////////
gulp.task('serve', ['build', 'browser-sync'], function() {
  gulp.watch(
    ['www/js/*.coffee', 'www/js/*/**.coffee'],
    {debounceDelay: 400},
    ['scripts']
  );
});

////////////////////
// browser-sync
////////////////////
gulp.task('browser-sync', function() {
  browserSync({
    server: {
      baseDir: __dirname + '/www/',
      directory: true
    },
    ghostMode: false,
    notify: false,
    debounce: 200,
    port: 8901,
    startPath: 'index.html'
  });

  gulp.watch([
    __dirname + '/www/**/*.{js,html,css,svg,png,gif,jpg,jpeg}'
  ], {
    debounceDelay: 400
  }, function() {
    browserSync.reload();
  });
});
