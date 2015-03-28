Admin.StoreRoute = Ember.Route.extend
  ticketsLoaded: false
  merchandiseLoaded: false

  setupController: (controller, model) ->
    controller.set("model", model)
    self = this
    unless @get("ticketsLoaded")
      promiseArray = @store.find("ticket_set")
      promiseArray.then ->
        self.set("ticketsLoaded", true)
        controller.set("ticketSets", promiseArray.content)
      , ->
        alert("could not load tickets")

    unless @get("merchandiseLoaded")
      console.log("Load Merch")
