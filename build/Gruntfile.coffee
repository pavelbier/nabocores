#global module:false
shell = require('shelljs')

module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    qunit:       
      files: ['../test/**/*.html']    
    watch:
      coffee_main:
        files: ['../js/main.coffee'],
        tasks: ['coffee:main','jshint:main','bundle:js']
      coffee_test:
        files: ['../test/tests.coffee'],
        tasks: ['coffee:test','jshint:test','qunit']
      coffee_app:
        files: ['../app/**/*.coffee'],
        tasks: ['coffee:app','jshint:app','qunit','bundle:js']
      less:
        files: ['../**/*.less'],
        tasks: ['less','bundle:css']
    less: 
      css:
        src: ['../css/project.less']
        dest: '../css/project.css'
    coffee:      
      main:
        files:
          '../js/main.js' : '../js/main.coffee'
      test:
        files:
          '../test/tests.js' : '../test/tests.coffee'
      app:
        expand: true
        cwd: '../app/'
        src: ['*.coffee']
        dest: '../app/'
        ext: '.js'
    jshint: 
      main:
        src: ['../js/main.js']     
      test:
        src: ['test/**/*.js']
      app:
        src: ['../app/**/*.js']
      options:
        curly: true
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noarg: true
        sub: true
        undef: true
        boss: true
        eqnull: true
        browser: true
        globals:
          jQuery:true
          console:true
          module:true
          require: true
          define: true
          requirejs: true
          describe: true
          expect: true
          it: true
          __dirname: true
          'Backbone': true
          'Handlebars': true
          '_': true
          '$': true   


  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'requireinit',"download requirejs and minify",->
    shell.cd __dirname
    shell.cp '-f','../components/requirejs/require.js','../js/require.js'
    shell.exec 'node ../components/r.js/index.js -o name=../js/require out=../js/require-min.js baseUrl=../js/'

  grunt.registerTask 'bundle:js',"bundle main.js file",->
    shell.cd __dirname
    shell.exec 'node ../components/r.js/index.js -o main.build.js',{async: true}

  grunt.registerTask 'bundle:css',"bundle main.css file",->
    shell.cd __dirname
    shell.exec 'node ../components/r.js/index.js -o cssIn=../css/main.css out=../css/main-min.css',{async: true}

  grunt.registerTask 'bundle',["bundle:js","bundle:css"]

  grunt.registerTask 'compile',['less','coffee','jshint','qunit','bundle']

  grunt.registerTask 'install',"install node dependencies",->
    shell.cd __dirname
    shell.exec 'npm install -g bower requirejs'
    grunt.task.run 'update'

  grunt.registerTask 'update',"update front dependencies",->
    shell.cd __dirname
    shell.exec 'bower install'
    grunt.task.run 'requireinit'
    grunt.task.run 'compile'

  # Default task.
  grunt.registerTask 'test',['jshint','qunit']
  grunt.registerTask 'default',['jshint','qunit']