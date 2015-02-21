"use strict"

@Application.factory "TCEData", ($http, $q) ->
  getMunicipios: () ->
    deferred = $q.defer()

    municipios = []
    $http.get('data/municipios.json')
    .then (municipiosResult) ->
      angular.forEach municipiosResult.data.nodes, (municipio, key) ->
        municipios.push
          id: municipio.node.id_municipio
          nome: municipio.node.ds_municipio

      $http.get('data/orgaos.json')
      .then (orgaosResult) ->
        angular.forEach orgaosResult.data.nodes, (orgao, key) ->
          municipios.filter (obj) ->
            if (obj.id == orgao.node.id_municipio)
              unless obj.orgaos?.length
                obj.orgaos = []
              obj.orgaos.push
                id: orgao.node.id_orgao_municipio
                nome: orgao.node.ds_orgao
        deferred.resolve municipios

    deferred.promise