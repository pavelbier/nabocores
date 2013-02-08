require 'shelljs/make'

target.all = ->
	target.install()

target.require_init = (cb) ->
	cd __dirname
	cp '../components/requirejs/require.js','../js/require.js'
	exec 'node ../components/r.js/index.js -o name=../js/require out=../js/require-min.js baseUrl=../js/', ->
		cb() if typeof cb=='function'

target.watch_less_init = ->
	exec 'npm install -g watch-less',{async:true}

target.watch_less = ->
	cd __dirname+'/../css'
	exec 'watch-less --e .css'

target.watch_coffee = ->
	cd __dirname+'/../js'
	exec 'coffee --watch --compile .'

target.compile_coffee = (cb) ->
	cd __dirname+'/../js'
	exec 'coffee --compile main.coffee', ->
		cb() if typeof cb=='function'

target.compile_less = (cb) ->
	cd __dirname+'/../css'
	exec 'lessc project.less project.css', ->
		cb() if typeof cb=='function'


target.bundle = ->
	cd __dirname
	exec 'node ../components/r.js/index.js -o main.build.js',{async:true}
	exec 'node ../components/r.js/index.js -o cssIn=../css/main.css out=../css/main-min.css',{async:true}

target.install = ->
	if not which 'git'
	  echo 'Sorry, this script requires git'
	  exit 1

	cd __dirname
	exec 'npm install -g bower requirejs less watch-less', target.update

target.update = ->
	cd __dirname
	exec 'bower install', ->
		target.compile_coffee ->
			target.compile_less ->
				cd __dirname
				target.require_init target.bundle