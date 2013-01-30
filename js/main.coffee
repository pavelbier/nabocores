require.config
  paths: 
    'jquery' : '../components/jquery/jquery'

require ['jquery'],($) ->
	$ ->
		console.log 'it works!',$
