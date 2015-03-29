Admin.StoreController = Ember.ObjectController.extend
  loaded: (->
    @get("ticketSets")? && @get("paymentTypes")?
  ).property("ticketSets", "merchandiseSets", "paymentTypes")

  ticketSets: null
  merchandiseSets: null
  paymentTypes: null
  currentPaymentType: null

  itemsInCart: (->
    (@get("tickets").length + @get("merchandise").length) > 0
  ).property("tickets.length", "merchandise.length")

  total: (->
    total = 0
    @get("tickets").forEach (item, index, enumerable) ->
      total += item.get("price")

    @get("merchandise").forEach (item, index, enumerable) ->
      total += item.get("price")

    total
  ).property("tickets.length", "merchandise.length")

  tickets: []
  merchandise: []

  showAllCart: false

  showTickets: false
  showMerchandise: false

  toggleTicketButtonName: (->
    return "Hide" if @get("showTickets")
    return "Show"
  ).property("showTickets")

  toggleMerchandiseButtonName: (->
    return "Hide" if @get("showMerchandise")
    return "Show"
  ).property("showMerchandise")

  addTicket: (ticket, concession) ->
    user_order_ticket = @store.createRecord('user_order_ticket')
    user_order_ticket.setProperties
      type: ticket
      concession: ticket.get("concessionPrice") && concession 
    @get("tickets").addObject(user_order_ticket)

  actions: 
    resetCart: ->
      @setProperties
        tickets: []
        merchandise: []

    addFullTicket: (ticket) ->
      @addTicket(ticket, false)

    addConcessionTicket: (ticket) ->
      @addTicket(ticket, true)

    removeTicket: (user_order_ticket) ->
      @get("tickets").removeObject(user_order_ticket)

    showCart: ->
      @set("showAllCart", true)

    hideCart: ->
      @set("showAllCart", false)

    toggleTickets: ->
      @set("showTickets", !@get("showTickets"))

    toggleMerchandise: ->
      @set("showMerchandise", !@get("showMerchandise"))

    checkOut: ->
      return unless confirm("Take $#{@get("total")} via #{@get("currentPaymentType.name")}") 
      data = 
        member_id: parseInt(@get("model.id"), 10)
        payment_type_id: parseInt(@get("currentPaymentType.id"), 10)
        tickets: []
        merchandise: []
      @get("tickets").forEach (item) ->
        ticketData =
          concession: item.get("concession")
          ticket_type_id: parseInt(item.get("type.id"), 10)
        data.tickets.addObject(ticketData)
      console.log(data)
      #@send("resetCart")
      #@send("hideCart")
      #@transitionToRoute("front_desk")
