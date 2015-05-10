# Generated on 2014-05-17 using generator-reveal 0.3.4
module.exports = (grunt) ->

    grunt.initConfig

        watch:

            livereload:
                options:
                    livereload: true
                files: [
                    'index.html'
                    'assets/*'
                    'assets/**/*'
                    'slides/*'
                    'slides/**/.html'
                    'slides/**/.md'
                    'js/*.js'
                    'css/*.css'
                ]

            index:
                files: [
                    'templates/*'
                    'slides/list.json'
                    'slides/*'
                    'slides/**/*.html'
                ]
                tasks: ['buildIndex']

            coffeelint:
                files: ['Gruntfile.coffee']
                tasks: ['coffeelint']

            jshint:
                files: ['js/*.js']
                tasks: ['jshint']

            sass:
                files: ['css/source/theme.scss']
                tasks: ['sass']

        sass:

            theme:
                files:
                    'css/theme.css': 'css/source/theme.scss'

        connect:

            livereload:
                options:
                    port: 9001
                    # Change hostname to '0.0.0.0' to access
                    # the server from outside.
                    hostname: '0.0.0.0'
                    base: '.'
                    open: true
                    livereload: true

        coffeelint:

            options:
                indentation:
                    value: 4

            all: ['Gruntfile.coffee']

        jshint:

            options:
                jshintrc: '.jshintrc'

            all: ['js/*.js']

        copy:

            dist:
                files: [{
                    expand: true
                    src: [
                        'slides/**'
                        'bower_components/**'
                        'js/**'
                        'css/*.css'
                    ]
                    dest: 'dist/'
                },{
                    expand: true
                    src: ['index.html']
                    dest: 'dist/'
                    filter: 'isFile'
                }]


    # Load all grunt tasks.
    require('load-grunt-tasks')(grunt)

    grunt.registerTask 'buildIndex',
        'Build index.html from templates/_index.html and slides/list.json.',
        ->
            indexTemplate = grunt.file.read 'templates/_index.html'
            sectionTemplate = grunt.file.read 'templates/_slide.html'

            importSlides = (slide) ->
                if "array" == grunt.util.kindOf(slide)
                    (importSlides(singleSlide) for singleSlide in slide)
                else if "string" == grunt.util.kindOf(slide)
                    contents:   grunt.file.read('slides/' + slide)
                    background: null
                else if slide.path
                    contents:   grunt.file.read('slides/' + slide.path)
                    background: slide.background
                else
                    contents:   null
                    background: slide.background


            html = grunt.template.process indexTemplate, data:
                slides:
                    importSlides(grunt.file.readJSON 'slides/list.json')
                section: (slide) ->
                    grunt.template.process sectionTemplate, data:
                        slide:      slide
                        contents:   slide.contents
                        background: slide.background

            grunt.file.write 'index.html', html

    grunt.registerTask 'test',
        '*Lint* javascript and coffee files.', [
            'coffeelint'
            'jshint'
        ]

    grunt.registerTask 'server',
        'Run presentation locally and start watch process (living document).', [
            'buildIndex'
            'sass'
            'connect:livereload'
            'watch'
        ]

    grunt.registerTask 'dist',
        'Save presentation files to *dist* directory.', [
            'test'
            'sass'
            'buildIndex'
            'copy'
        ]

    # Define default task.
    grunt.registerTask 'default', [
        'test'
        'server'
    ]
