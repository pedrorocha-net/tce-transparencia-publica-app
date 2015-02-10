@Application.controller 'OrgaosDetalharCtrl'
, ($scope, $http, $stateParams, ngProgressLite, TCEData) ->
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
    url = 'http://www.portaldocidadao.tce.sp.gov.br/despesa_total_xml/'
    url += "#{municipioId}/#{orgaoId}/#{ano}/despesas"
    $http
      method: "GET"
      url: url
    .then (data) ->
      $scope.despesas = data.data
      ngProgressLite.done()
