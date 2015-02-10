@Application.controller 'MunicipiosDetalharCtrl'
, ($scope, $stateParams, ngProgressLite, TCEData) ->
  ngProgressLite.start()
  TCEData.getMunicipios().then (municipios) ->
    municipios.filter (obj) ->
      if (obj.id == $stateParams.municipioId)
        $scope.municipio = obj
        ngProgressLite.done()