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
        controller.set("paymentTypes", paymentTypePromise.content)
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
      console.log("Load Merch")
