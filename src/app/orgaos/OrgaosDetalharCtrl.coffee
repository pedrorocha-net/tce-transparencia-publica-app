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

      $scope.valorEmpenhadoTotal = 0
      $scope.valorLiquidadoTotal = 0
      $scope.valorPagoTotal = 0
      $scope.despesas.filter (obj) ->
        $scope.valorEmpenhadoTotal +=
          $scope.limparNumero obj.node.vl_empenhado
      $scope.despesas.filter (obj) ->
        $scope.valorLiquidadoTotal +=
          $scope.limparNumero obj.node.vl_liquidado
      $scope.despesas.filter (obj) ->
        $scope.valorPagoTotal +=
          $scope.limparNumero obj.node.vl_pago

      $scope.chartOptions =
        horizontalBars: true
        reverseData: true
        
      $scope.chartData =
        labels: ['Empenhado', 'Liquidado', 'Pago']
        series: [[
                   $scope.valorEmpenhadoTotal
                   $scope.valorLiquidadoTotal
                   $scope.valorPagoTotal
                 ]]

      ngProgressLite.done()

  $scope.limparNumero = (string) ->
    parseFloat string.replace(/\./g, '').replace(',', '.')
