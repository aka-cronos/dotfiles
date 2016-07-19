// Dependencies
var gulp          = require('gulp');
var stylus        = require('gulp-stylus');
var postcss       = require('gulp-postcss');
var rupture       = require('rupture');
var lost          = require('lost');
var rucksack      = require('rucksack-css');
var autoprefixer  = require('autoprefixer');
var cssmin        = require('gulp-cssmin');
var imagemin      = require('gulp-imagemin');
var rename        = require('gulp-rename');
var concat        = require('gulp-concat');
var uglify        = require('gulp-uglify');
var browserSync   = require('browser-sync').create();
var reload        = browserSync.reload;

// Paths
var paths = {
  html:     './**/*.html',
  img:      './img/',
  css:      './css/',
  js:       './js/',
  images:   './img/**/*.{JPG,jpg,png,gif}',
  styles:   './css/stylus/styles.styl',
  stylus:   './css/stylus/**/*.styl',
  scripts:  [
              './js/vendor/*.js',
              './js/modules/*.js'
            ]
};

// server task - Run server
gulp.task('server', function() {
  browserSync.init({
    server: {
        baseDir: "./"
    },
    port: 3000,
    notify: false
  });

  gulp.watch(paths.html).on('change', reload);
  gulp.watch(paths.stylus, gulp.series('styles'));
  gulp.watch(paths.scripts, gulp.series('scripts'));
});

// Stylus Task - Compiles stylus file
gulp.task('stylus', function() {
  var stylus_options = {
    use : [     
        rupture()
    ]
  }
  
  return gulp.src(paths.styles)
    .pipe(stylus(stylus_options))
    .pipe(gulp.dest(paths.css));
});

// Postcss Task - Run postcss processors
gulp.task('autoprefixer', function () {
    var postcss      = require('gulp-postcss');
    var sourcemaps   = require('gulp-sourcemaps');
    var autoprefixer = require('autoprefixer');
    var browserslist = require('browserslist');

    return gulp.src(paths.css + 'styles.css')
        .pipe(sourcemaps.init())
        .pipe(postcss([ autoprefixer({ browsers: ['last 2 versions'] }) ]))
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest('paths.css'));
});

// Mincss - Minify style.css file
gulp.task ('mincss', function() {
  return gulp.src(paths.css + 'styles.css')
    .pipe(cssmin())
    .pipe(rename({
      suffix: '.min'
    }))
    .pipe(gulp.dest(paths.css));
});

// Concatjs Task - Concatenates *.js files
gulp.task ('concatjs', function() {
  return gulp.src(paths.scripts)
    .pipe(concat('main.js'))
    .pipe(gulp.dest(paths.js));
});

// Uglify Task - Compress *.js files
gulp.task('uglify', function() {
  return gulp.src(paths.js + 'main.js')
    .pipe(uglify())
    .pipe(rename({
      suffix: '.min'
    }))
    .pipe(gulp.dest(paths.js));
});

// Styles:watch Task - Reloads html files
gulp.task('styles:watch', function(){
  return gulp.src(paths.styles)
    .pipe(reload({ stream:true }));
});

// Scripts:watch Task - Reloads html files
gulp.task('scripts:watch', function(){
  return gulp.src(paths.scripts)
    .pipe(reload({ stream:true }));
});

// Optimize images
gulp.task('images', function() {
  return gulp.src(paths.images)
    .pipe(imagemin())
    .pipe(gulp.dest(paths.img));
});

// Styles Task
gulp.task('styles', gulp.series('stylus', 'postcss', 'mincss', 'styles:watch'));

// Scripts Task
gulp.task('scripts', gulp.series('concatjs', 'uglify', 'scripts:watch'));

// Build Task
gulp.task('build', gulp.parallel('styles', 'scripts'));

// Develop Task
gulp.task('develop', gulp.series('build', 'server'));

// Production Task
gulp.task('production', gulp.series('build', 'images', 'server'));