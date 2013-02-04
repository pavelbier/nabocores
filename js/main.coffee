require.config
  paths: 
    'jquery' : '../components/jquery/jquery'
    'underscore' : '../components/underscore/underscore'
    'backbone' : '../components/backbone/backbone'
    'text' : '../components/requirejs-text/text'
  shim:
  	'underscore' :
  		exports: '_'
  	'backbone':
  		deps: ['underscore','jquery']
  		exports: 'Backbone'
require ['jquery'],($) ->
	$ ->
		$('<h1>',{text: 'It Works!'}).appendTo($('body'))
