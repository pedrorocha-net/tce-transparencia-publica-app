"use strict"

@Application.factory "TCEService", ($http) ->
  getDespesas: (municipioId, orgaoId, ano) ->
    urlBase = 'http://www.portaldocidadao.tce.sp.gov.br'
    url = "/api_json_despesas_total/#{municipioId}/#{orgaoId}/#{ano}"
    $http
      method: "GET"
      url: urlBase + url