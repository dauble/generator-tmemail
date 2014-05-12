module.exports = (grunt) ->

  require('load-grunt-tasks') grunt
  require("time-grunt") grunt

  config =
      src: 'app'
      build: 'build'

  grunt.initConfig

    config: config

    connect:
      options:
        port: 9000,
        open: true,
        livereload: 35729,
        # Change this to '0.0.0.0' to access the server from outside
        hostname: 'localhost'
      livereload:
        options:
          middleware: (connect) ->
            return [
              connect.static '<%= config.src %>/_tmp'
              connect.static grunt.config.data.config.src
            ]

    clean:
      dev:
        dot: true
        src: [
          '<%= config.src %>/_tmp'
        ]

    sass:
      dist:
        options:
          outputStyle: 'expanded'
          sourceComments: 'normal'
        files:
          '<%= config.src %>/_tmp/stylesheets/styles.css': '<%= config.src %>/stylesheets/styles.scss'

    autoprefixer:
      dist:
        src: '<%= config.src %>/_tmp/stylesheets/styles.css'

    watch:
      scss:
        options:
          spawn: false
        files: ['<%= config.src %>/stylesheets/{,*/}*.scss']
        tasks: ['sass:dist', 'autoprefixer', 'notify:scss']

      livereload:
        options:
          livereload: true
          spawn: false
        files: [
          '<%= config.src %>/_tmp/stylesheets/{,*/}*.css'
          '<%= config.src %>/{,*/}*.html'
        ]

    replace:
      dist:
        options:
          patterns: [
            match: 'include',
            replacement: '<%= grunt.file.read(grunt.config.data.config.src + "/_tmp/stylesheets/styles.css") %>'
          ]
        files: [
          expand: true
          flatten: true
          src: ['<%= config.src %>/{,*/}*.html']
          dest: '<%= config.src %>/_tmp'
        ]

    http:
      inliner:
        options:
          url: 'http://zurb.com/ink/skate-proxy.php'
          method: 'POST'
          form: {}
          sourceField: 'form.source'
          json: true
        files: ( ->

            matches = grunt.file.expand({cwd: config.src + '/_tmp'}, '*.html')

            f = []
            matches.forEach (value, index) ->

              prop = '<%= config.build %>/' + value
              obj = {}
              obj[prop] = '<%= config.src %>/_tmp/' + value
              f.push obj

            f
          )()

    notify:
      scss:
        options:
          title: 'Sass compiled'
          message: 'Grunt successfully compiled your Sass files'

  grunt.registerTask "default", [
    "clean:dev"
    "sass:dist"
    "connect:livereload"
    "watch"
  ]

  grunt.registerTask "build", [
    "clean:dev"
    "sass:dist"
    "replace"
    "http:inliner"
  ]