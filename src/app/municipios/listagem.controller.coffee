"use strict"

@Application.controller 'MunicipiosListagemCtrl'
, ($scope, $http, ngProgressLite, TCEData) ->
  query =
    nome: ''

  ngProgressLite.start()
  TCEData.getMunicipios().then (data) ->
    $scope.municipios = data
    ngProgressLite.done()