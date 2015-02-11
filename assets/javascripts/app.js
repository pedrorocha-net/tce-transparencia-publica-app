this.Application = angular.module('starter', ['ionic', 'ngProgressLite', 'xml', 'templateCache']);

this.Application.run(function($ionicPlatform) {
  return $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      return StatusBar.styleDefault();
    }
  });
});

this.Application.config(function($stateProvider, $urlRouterProvider, $httpProvider) {
  $httpProvider.interceptors.push('xmlHttpInterceptor');
  $stateProvider.state('app', {
    url: '/app',
    abstract: true,
    templateUrl: 'partials/menu.html',
    controller: 'AppCtrl'
  }).state('app.municipios', {
    url: '/municipios',
    views: {
      'menuContent': {
        templateUrl: 'partials/app/municipios/listagem.html',
        controller: 'MunicipiosListagemCtrl'
      }
    }
  }).state('app.detalharMunicipio', {
    url: '/municipio/:municipioId',
    views: {
      'menuContent': {
        templateUrl: 'partials/app/municipios/detalhar-municipio.html',
        controller: 'MunicipiosDetalharCtrl'
      }
    }
  }).state('app.detalharOrgao', {
    url: '/orgao/:municipioId/:orgaoId',
    views: {
      'menuContent': {
        templateUrl: 'partials/app/orgaos/detalhar-orgao.html',
        controller: 'OrgaosDetalharCtrl'
      }
    }
  });
  return $urlRouterProvider.otherwise('/app/municipios');
});

"use strict";
this.Application.controller('AppCtrl', function($scope, $ionicModal, $timeout) {});

this.Application.controller('MunicipiosDetalharCtrl', function($scope, $stateParams, ngProgressLite, TCEData) {
  ngProgressLite.start();
  return TCEData.getMunicipios().then(function(municipios) {
    return municipios.filter(function(obj) {
      if (obj.id === $stateParams.municipioId) {
        $scope.municipio = obj;
        return ngProgressLite.done();
      }
    });
  });
});

"use strict";
this.Application.controller('MunicipiosListagemCtrl', function($scope, $http, ngProgressLite, TCEData) {
  var query;
  query = {
    nome: ''
  };
  ngProgressLite.start();
  return TCEData.getMunicipios().then(function(data) {
    $scope.municipios = data;
    return ngProgressLite.done();
  });
});

"use strict";
this.Application.factory("TCEData", function($http, $q) {
  return {
    getMunicipios: function() {
      var deferred, municipios;
      deferred = $q.defer();
      municipios = [];
      $http.get('data/municipios.json').then(function(municipiosResult) {
        angular.forEach(municipiosResult.data.nodes, function(municipio, key) {
          return municipios.push({
            id: municipio.node.id_municipio,
            nome: municipio.node.ds_municipio
          });
        });
        return $http.get('data/orgaos.json').then(function(orgaosResult) {
          angular.forEach(orgaosResult.data.nodes, function(orgao, key) {
            return municipios.filter(function(obj) {
              if (obj.id === orgao.node.id_municipio) {
                obj.orgaos = [];
                return obj.orgaos.push({
                  id: orgao.node.id_orgao_municipio,
                  nome: orgao.node.ds_orgao
                });
              }
            });
          });
          return deferred.resolve(municipios);
        });
      });
      return deferred.promise;
    }
  };
});

this.Application.controller('OrgaosDetalharCtrl', function($scope, $http, $stateParams, ngProgressLite, TCEData) {
  $scope.init = function() {
    $scope.anoPesquisado = '2014';
    $scope.municipio = {};
    $scope.orgao = {};
    ngProgressLite.start();
    return TCEData.getMunicipios().then(function(municipios) {
      return municipios.filter(function(obj) {
        if (obj.id === $stateParams.municipioId) {
          $scope.municipio = obj;
          return $scope.municipio.orgaos.filter(function(obj2) {
            if (obj2.id === $stateParams.orgaoId) {
              $scope.orgao = obj2;
              $scope.buscarDados($scope.municipio.id, $scope.orgao.id, $scope.anoPesquisado);
              return ngProgressLite.done();
            }
          });
        }
      });
    });
  };
  return $scope.buscarDados = function(municipioId, orgaoId, ano) {
    var url;
    ngProgressLite.start();
    url = 'http://www.portaldocidadao.tce.sp.gov.br/despesa_total_xml/';
    url += municipioId + "/" + orgaoId + "/" + ano + "/despesas";
    return $http({
      method: "GET",
      url: url
    }).then(function(data) {
      $scope.despesas = data.data;
      return ngProgressLite.done();
    });
  };
});
