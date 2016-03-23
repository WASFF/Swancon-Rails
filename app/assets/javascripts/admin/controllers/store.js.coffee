Admin.StoreController = Ember.ObjectController.extend
  loaded: (->
    @get("ticketSets")? && @get("paymentTypes")? && @get("merchandiseSets")?
  ).property("ticketSets", "merchandiseSets", "paymentTypes")

  ticketSets: null
  merchandiseSets: null
  paymentTypes: null
  currentPaymentType: null

  itemsInCart: (->
    (@get("tickets").length + @get("merchandise").length) > 0
  ).property("tickets.length", "merchandise.length")

  checkOutDisabled: (->
    properties = @getProperties('itemsInCart', 'currentPaymentType')
    unless properties.itemsInCart
      return true
    unless properties.currentPaymentType? && properties.currentPaymentType.get('id')?
      return true
    false
  ).property("itemsInCart", "currentPaymentType")

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
      concession: ticket.get("concessionPrice")? && concession
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

    removeMerchandise: (user_order_merchandise) ->
      @get("merchandise").removeObject(user_order_merchandise)

    addMerchandise: (merchandise) ->
      if merchandise.get("options.length") > 0
        @send 'showModal', 'select-merchandise-option', merchandise
      else
        @send 'addMerchandiseWithOptions', merchandise, []

    addMerchandiseWithOptions: (merchandise, options) ->
      user_order_merchandise = @store.createRecord('user_order_merchandise', {
        type: merchandise
      })
      user_order_merchandise_options = []

      merchandise.get("option_sets").forEach (set) =>
        user_order_merchandise_option = @store.createRecord 'user_order_merchandise_option',
          option: options[set.get("id")]
        user_order_merchandise.get("options").addObject(user_order_merchandise_option)

      @get("merchandise").addObject(user_order_merchandise)

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
      @get("merchandise").forEach (item) ->
        options_ids = []
        item.get("options").forEach (option) ->
          options_ids.addObject(option.get("option.id"))
        merchData =
          merchandise_type_id: parseInt(item.get("type.id"), 10)
          merchandise_option_ids: options_ids
        data.merchandise.addObject(merchData)

      p = Admin.Api.post("/store/purchase", data)
      p.done (data) =>
        dataObject = Ember.Object.create()
        dataObject.set("email", data.email)
        dataObject.set("userOrderId", data.user_order_id)
        dataObject.set("invoiceNumber", data.invoice_number)
        dataObject.set("conMode", data.con_mode)
        dataObject.set("paymentId", data.payment_id)
        dataObject.set("receiptNumber", data.receipt_number)
        @send("resetCart")
        @send("hideCart")
        @send 'showModal', 'purchase-complete', dataObject
      p.fail (jqXHR, textStatus, error) =>
        alert("ERROR: #{error}")
