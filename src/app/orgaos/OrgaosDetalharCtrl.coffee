@Application.controller 'OrgaosDetalharCtrl'
, ($scope, $http, $stateParams, ngProgressLite, TCEData, TCEService) ->
  $scope.init = () ->
    $scope.anoPesquisado = '2014'
    $scope.municipio = {}
    $scope.orgao = {}
    ngProgressLite.start()
    TCEData.getMunicipios().then (municipios) ->
      municipios.filter (obj) ->
        if (obj.id == $stateParams.municipioId)
          $scope.municipio = obj
          $scope.municipio.orgaos.filter (obj2) ->
            if (obj2.id == $stateParams.orgaoId)
              $scope.orgao = obj2
              $scope.buscarDados(
                $scope.municipio.id
                $scope.orgao.id
                $scope.anoPesquisado
              )
              ngProgressLite.done()

  $scope.buscarDados = (municipioId, orgaoId, ano) ->
    ngProgressLite.start()
    TCEService.getDespesas(municipioId, orgaoId, ano).then (data) ->
      $scope.despesas = data.data.nodes
      console.log $scope.despesas
      ngProgressLite.done()
