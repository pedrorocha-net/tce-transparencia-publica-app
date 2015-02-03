@Application.controller 'AppCtrl', ($scope, $ionicModal, $timeout) ->

@Application.controller 'CidadesCtrl', ($scope, $http, ngProgressLite) ->
  ngProgressLite.start()
  $http.get('http://www.portaldocidadao.tce.sp.gov.br/api_json_municipios')
  .then (cidadesResult) ->
    $scope.cidades = []
    angular.forEach cidadesResult.data.nodes, (cidade, key) ->
      $scope.cidades[cidade.node.id_municipio] =
        id: cidade.node.id_municipio
        nome: cidade.node.ds_municipio

    ngProgressLite.set 0.5

    $http.get('http://www.portaldocidadao.tce.sp.gov.br/api_json_orgaos')
    .then (orgaosResult) ->
      angular.forEach orgaosResult.data.nodes, (orgao, key) ->
        $scope.cidades[orgao.node.id_municipio].orgaos = []
        $scope.cidades[orgao.node.id_municipio].orgaos.push
          id: orgao.node.id_orgao_municipio
          nome: orgao.node.ds_orgao
      ngProgressLite.done()
      console.log $scope.cidades

    url = 'http://www.portaldocidadao.tce.sp.gov.br/despesa_total_xml/'
    url += '99/264/2014/despesas'
    $http.get(url).success (data) ->
      console.log data