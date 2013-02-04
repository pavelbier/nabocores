require.config
  paths: 
    'jquery' : '../components/jquery/jquery'
    'text' : '../components/requirejs-text/text'

require ['jquery'],($) ->
	$ ->
		$('<h1>',{text: 'It Works!'}).appendTo($('body'))
