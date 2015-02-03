gulp = require 'gulp'

$ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'run-sequence']
});

sources =
  sass: 'src/assets/scss/*.scss'
  html: [
    'src/**/*.html'
  ]
  coffee: [
    'src/**/*.coffee'
  ]

destinations =
  css: 'www/assets/stylesheets'
  html: 'www/'
  js: 'www/assets/javascripts'

filesToMove = [
  'src/lib/**'
  'src/assets/images/**'
]

isProd = $.util.env.type is 'prod'

###
  Compile SASS files
###
gulp.task 'style', ->
  if isProd
    gulp.src(sources.sass)
    .pipe($.rubySass({style: 'compressed'}))
    .on('error', (err) ->
      console.log err.message
    )
    .pipe($.minifyCss())
    .pipe(gulp.dest(destinations.css))
  else
    gulp.src(sources.sass)
    .pipe($.rubySass({style: 'expanded'}))
    .on('error', (err) ->
      console.log err.message
    )
    .pipe(gulp.dest(destinations.css))

###
  Minify the app HTML partials and convert them into JS using templateCache()
###
gulp.task 'partials', ->
  gulp.src([
    'src/{app,components}/**/*.html'
    'src/partials/*.html'
  ])
  .pipe($.minifyHtml(
      empty: true,
      spare: true,
      quotes: true
    ))
  .pipe($.angularTemplatecache('templateCacheHtml.js',
      module: 'templateCache'
      standalone: true
      root: 'partials'
    ))
  .pipe(gulp.dest('.tmp/inject/'))

###
  Inject files(templateCache, css, js, etc) and minify the final HTML
###
gulp.task "html", ["partials"], ->
  htmlFilter = $.filter("*.html")
  gulp.src([
    "src/*.html"
    ".tmp/*.html"
  ]).pipe($.inject(gulp.src(".tmp/inject/templateCacheHtml.js",
      read: false
    ),
    starttag: "<!-- inject:partials -->"
    ignorePath: ".tmp"
    addRootSlash: false
  ))
  .pipe(htmlFilter)
  .pipe($.minifyHtml(
      empty: true
      spare: true
      quotes: true
    ))
  .pipe(htmlFilter.restore())
  .pipe(gulp.dest(destinations.html))
  .pipe $.size(
    title: destinations.html
    showFiles: true
  )
  gulp.src(".tmp/inject/templateCacheHtml.js",
    base: ".tmp"
  ).pipe gulp.dest("www")

###
  Run Coffee files through Coffee Lint
###
gulp.task 'lint', ->
  gulp.src(sources.coffee)
  .pipe($.coffeelint())
  .pipe($.coffeelint.reporter())

###
  Compile Coffeescript files
###
gulp.task 'coffee', ->
  if isProd
    gulp.src(sources.coffee)
    .pipe($.coffee({bare: true}).on('error', $.util.log))
    .pipe($.concat('app.js'))
    .pipe($.uglify())
    .pipe(gulp.dest(destinations.js))
  else
    gulp.src(sources.coffee)
    .pipe($.coffee({bare: true}).on('error', $.util.log))
    .pipe($.concat('app.js'))
    .pipe(gulp.dest(destinations.js))

###
  Copy the base files, like bower components, to the deploy folder
###
gulp.task "copyBaseFiles", ["clean"], ->
  gulp.src(filesToMove,
    base: "src"
  ).pipe gulp.dest("www")

###
  Keep watching files for changes to update them automatically
###
gulp.task 'watch', ->
  gulp.watch sources.sass, ['style']
  gulp.watch sources.coffee, ['lint', 'coffee']
  gulp.watch sources.html, ['html']

###
  Remove the "www" folder
###
gulp.task 'clean', ->
  gulp.src([destinations.html], {read: false}).pipe($.clean())

###
  Run the entire process
###
gulp.task 'build', ->
  $.runSequence 'clean', ['copyBaseFiles', 'style', 'lint', 'coffee', 'html']

###
  Default command to run when calling just "gulp"
###
gulp.task 'default', ['build', 'watch']
