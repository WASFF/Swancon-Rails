Admin.MemberTicketsController = Ember.ArrayController.extend

  actions:
    redeemTicket: (ticket) ->
      ticket.setProperties
        redeemedAt: new Date()
        working: true
      ticket.save().then ->
        ticket.set("working", false)
      , -> 
        alert("Error while redeeming ticket :/")

    unRedeemTicket: (ticket) ->
      ticket.setProperties
        redeemedAt: null
        working: true
      ticket.save().then ->
        ticket.set("working", false)
      , -> 
        alert("Error while redeeming ticket :/")

