@Application = angular.module 'starter', [
  'ionic'
  'ngProgressLite'
  'xml'
  'templateCache'
  'angular-chartist'
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

  .state 'app.municipios',
    url: '/municipios'
    views:
      'menuContent':
        templateUrl: 'partials/app/municipios/listagem.html'
        controller: 'MunicipiosListagemCtrl'

  .state 'app.detalharMunicipio',
    url: '/municipio/:municipioId'
    views:
      'menuContent':
        templateUrl: 'partials/app/municipios/detalhar-municipio.html'
        controller: 'MunicipiosDetalharCtrl'

  .state 'app.detalharOrgao',
    url: '/orgao/:municipioId/:orgaoId'
    views:
      'menuContent':
        templateUrl: 'partials/app/orgaos/detalhar-orgao.html'
        controller: 'OrgaosDetalharCtrl'

  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise '/app/municipios'