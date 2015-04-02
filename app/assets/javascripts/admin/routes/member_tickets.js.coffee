Admin.MemberTicketsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set("member", model)
    if @fetchTickets
      promiseArray = @store.find('user_order_ticket', {member_id: model.get("id")})
      promiseArray.then ->
        #todo: this is read only?
        #model.set("tickets", promiseArray.content)
        controller.set("model", promiseArray.content)
      , ->
        controller.setProperties
          model: []
          error: "Could not load ticketss"
    else
      controller.set("model", model.get("tickets")) unless @fetchTickets

    return

  model: (params, transition) ->
    @fetchTickets = true
    @store.find('member', params.member_id)

  beforeModel: ->
    @fetchTickets = false
