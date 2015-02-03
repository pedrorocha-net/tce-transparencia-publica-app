angular.module('starter.controllers', [])

  .controller('AppCtrl', function ($scope, $ionicModal, $timeout) {

  })

  .controller('CidadesCtrl', function ($scope, $http, ngProgressLite) {
    ngProgressLite.start();
    $http.get('http://www.portaldocidadao.tce.sp.gov.br/api_json_municipios').then(function (cidadesResult) {
      $scope.cidades = [];
      angular.forEach(cidadesResult.data.nodes, function (cidade, key) {
        $scope.cidades[cidade.node.id_municipio] = {
          id: cidade.node.id_municipio,
          nome: cidade.node.ds_municipio
        };
      });
      ngProgressLite.set(0.5);

      $http.get('http://www.portaldocidadao.tce.sp.gov.br/api_json_orgaos').then(function (orgaosResult) {
        angular.forEach(orgaosResult.data.nodes, function (orgao, key) {
          $scope.cidades[orgao.node.id_municipio].orgaos = [];
          $scope.cidades[orgao.node.id_municipio].orgaos.push({
            id: orgao.node.id_orgao_municipio,
            nome: orgao.node.ds_orgao
          });
        });
        ngProgressLite.done();
        console.log($scope.cidades);
      });
    });
  })

  .controller('CidadeCtrl', function ($scope, $stateParams) {
  });
