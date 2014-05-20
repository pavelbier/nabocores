gulp        = require 'gulp'
prefix      = require 'gulp-autoprefixer'
less        = require 'gulp-less'
cssmin      = require 'gulp-cssmin'
rename      = require 'gulp-rename'
rjs         = require 'gulp-requirejs'
uglify 	    = require 'gulp-uglify'
coffee      = require 'gulp-coffee'
jshint 	    = require 'gulp-jshint'
qunit 	    = require 'gulp-qunit'
watch 	    = require 'este-watch'
concat      = require 'gulp-concat'
runSequence = require 'run-sequence'
shell       = require('gulp-shell')

sources =
	coffeeMain: '../js/**/*.coffee'
	coffeeApp: '../app/**/*.coffee'
	coffeeTest: '../test/**/*.coffee'
	less: '../css/**/*.less'
	test: '../test/**/*.js'
	css: '../css/**/*.css'
destinations = 
	jsMain: '../js'
	jsApp: '../app'
	jsTest: '../test'
	css: '../css'

gulp.task 'init', ->
	gulp.src '../components/requirejs/require.js'
		.pipe uglify()
		.pipe concat 'require-min.js'
		.pipe gulp.dest '../js/'

gulp.task 'less', ->
	gulp.src sources.less
		.pipe less()
		.pipe gulp.dest destinations.css

gulp.task 'css:main', ->
	gulp.src '../css/main.css'
		.pipe prefix "> 1%"
		.pipe cssmin keepSpecialComments: 0
		.pipe rename suffix: '-min'
		.pipe gulp.dest destinations.css

gulp.task 'coffee:main', ->
	gulp.src sources.coffeeMain
		.pipe coffee bare: true
		.pipe gulp.dest destinations.jsMain

gulp.task 'coffee:app', ->
	gulp.src sources.coffeeApp
		.pipe coffee bare: true
		.pipe gulp.dest destinations.jsApp

gulp.task 'coffee:test', ->		
	gulp.src sources.coffeeTest
		.pipe coffee bare: true
		.pipe gulp.dest destinations.jsTest

gulp.task 'coffee', ['coffee:main','coffee:app','coffee:test']

gulp.task 'lint', ->
	gulp.src '../js/main.js'
		.pipe jshint sub: true
		.pipe jshint.reporter 'jshint-stylish'

gulp.task 'requirejsbuild', ->
	rjs
		baseUrl: "../js"
		name: "main"
		mainConfigFile: "../js/main.js"
		optimizeCss: "standard"
		out: "../js/main-min.js"
	.pipe gulp.dest '../js'

gulp.task 'minifyjs', ->
	gulp.src '../js/main-min.js'
		.pipe uglify()
		.pipe gulp.dest destinations.jsMain

gulp.task 'js', () ->
	runSequence [
		'coffee'
		'requirejsbuild'
		'lint'
		'minifyjs'
	]

gulp.task 'css', () ->
	runSequence [
		'less'
		'css:main'
	]

gulp.task 'watch', ->
	gulp.watch [sources.coffeeMain,sources.coffeeTest,sources.coffeeApp], ['js']
	gulp.watch [sources.less,sources.css], ['css']
	gulp.watch [sources.test,sources.coffeeApp], ['test']

gulp.task 'test', ->
	gulp.src '../test/*.html'
		.pipe qunit()	

gulp.task 'install', ->
	gulp.start 'update', ->
		gulp.start 'init','bundle'

gulp.task 'update', shell.task [
	'bower install'
]

gulp.task 'run', ->
	runSequence [
		'bundle'
		'test'
		'watch'
	]

gulp.task 'bundle', ['css','js']

gulp.task 'default', ['run']
