@Application = angular.module 'starter', [
  'ionic'
  'ngProgressLite'
  'xml'
  'templateCache'
]

@Application.run ($ionicPlatform) ->
  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar
    # above the keyboard for form inputs)
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true
    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleDefault()

@Application.config ($stateProvider, $urlRouterProvider, $httpProvider) ->
  $httpProvider.interceptors.push 'xmlHttpInterceptor'

  $stateProvider
  .state 'app',
    url: '/app'
    abstract: true
    templateUrl: 'partials/menu.html'
    controller: 'AppCtrl'

  .state 'app.cidades',
    url: '/cidades'
    views:
      'menuContent':
        templateUrl: 'partials/app/cidades/cidades.html'
        controller: 'CidadesCtrl'

  .state 'app.cidade',
    url: '/cidade/:cidadeId'
    views:
      'menuContent':
        templateUrl: 'partials/app/cidades/cidade.html'
        controller: 'CidadeCtrl'

  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise '/app/cidades'