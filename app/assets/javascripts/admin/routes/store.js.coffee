Admin.StoreRoute = Ember.Route.extend
  ticketsLoaded: false
  paymentTypesLoaded: false
  merchandiseLoaded: false

  setupController: (controller, model) ->
    controller.set("model", model)
    self = this
    unless @get("paymentTypesLoaded")
      paymentTypePromise = @store.find("payment_type")
      paymentTypePromise.then ->
        self.set("paymentTypesLoaded", true)
        paymentTypeList = [Ember.Object.create()].concat(paymentTypePromise.content.content)
        controller.set("paymentTypes", paymentTypeList)
      , ->
        alert("could not load payment types")

    unless @get("ticketsLoaded")
      ticketsPromise = @store.find("ticket_set")
      ticketsPromise.then ->
        self.set("ticketsLoaded", true)
        controller.set("ticketSets", ticketsPromise.content)
      , ->
        alert("could not load tickets")

    unless @get("merchandiseLoaded")
      merchPromise = @store.find("merchandise_set")
      merchPromise.then ->
        self.set("merchandiseLoaded", true)
        controller.set("merchandiseSets", merchPromise.content)
      , ->
        alert("could not load merchandise")
