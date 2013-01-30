require 'shelljs/make'

target.all = ->
	target.install()

target.require_init = (cb) ->
	cd __dirname+'/../build'
	cat('../components/requirejs/require.js','../components/jquery/jquery.js').to('../js/require-jquery.js')
	exec 'node node_modules/requirejs/bin/r.js -o name=require-jquery out=../js/require-jquery-min.js baseUrl=../js/', ->
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
	exec 'node node_modules/requirejs/bin/r.js -o app.build.js',{async:true}
	exec 'node node_modules/requirejs/bin/r.js -o cssIn=../css/main.css out=../css/main-min.css',{async:true}

target.install = ->
	if not which 'git'
	  echo 'Sorry, this script requires git'
	  exit 1

	exec 'npm install -g bower less watch-less', ->
		cd __dirname
		exec 'bower install', ->
			target.compile_coffee ->
				target.compile_less ->
					cd __dirname
					exec 'npm install requirejs', ->
						target.require_init(target.bundle)