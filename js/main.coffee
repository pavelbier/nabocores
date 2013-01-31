require.config
  paths: 
    'jquery' : '../components/jquery/jquery'

require ['jquery'],($) ->
	$ ->
		$('<h1>',{text: 'It Works!'}).appendTo($('body'))
