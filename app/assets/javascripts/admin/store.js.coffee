Admin.ApplicationStore = DS.Store.extend()
Admin.ApplicationAdapter = DS.ActiveModelAdapter.extend()
Admin.ApplicationSerializer = DS.ActiveModelSerializer.extend()

DS.RESTAdapter.reopen
  namespace: "api/v1"

