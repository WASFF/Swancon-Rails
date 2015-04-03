Admin.ApplicationStore = DS.Store.extend()
Admin.ApplicationAdapter = DS.ActiveModelAdapter.extend()
Admin.ApplicationSerializer = DS.ActiveModelSerializer.extend()

DS.RESTAdapter.reopen
  namespace: "api/v1"

class api
  @request: (path, type, data) ->
    url = "/api/v1/" + path
    data ?= {}
    headers = {}

    requestObj = 
      dataType: "json"
      type: type
      method: type
      url: url
      data: data
      headers: headers

    return jQuery.ajax(requestObj)

  @put: (path, data) ->
    @request path, 'PUT', data

  @get: (path, data) ->
    @request path, 'GETq', data

  @post: (path, data) ->
    @request path, 'POST', data

  @delete: (path, data) ->
    @request path, 'DELETE', data

Admin.Api = api  
