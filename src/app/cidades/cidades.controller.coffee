@Application.controller 'AppCtrl', ($scope, $ionicModal, $timeout) ->

@Application.controller 'CidadesCtrl',
  ($scope, $http, ngProgressLite, TCEData) ->
    query =
      nome: ''

    ngProgressLite.start()
    $http.get('data/municipios.json')
    .then (cidadesResult) ->
      $scope.cidades = []
      angular.forEach cidadesResult.data.nodes, (cidade, key) ->
        $scope.cidades.push
          id: cidade.node.id_municipio
          nome: cidade.node.ds_municipio

      ngProgressLite.set 0.5

      $http.get('data/orgaos.json')
      .then (orgaosResult) ->
        angular.forEach orgaosResult.data.nodes, (orgao, key) ->
          $scope.cidades.filter (obj) ->
            if (obj.id == orgao.node.id_municipio)
              obj.orgaos = []
              obj.orgaos.push
                id: orgao.node.id_orgao_municipio
                nome: orgao.node.ds_orgao
        ngProgressLite.done()
        TCEData.municipios = $scope.cidades

#      url = 'http://www.portaldocidadao.tce.sp.gov.br/despesa_total_xml/'
#      url += '99/264/2014/despesas'
#      $http.get(url).success (data) ->
#        console.log data