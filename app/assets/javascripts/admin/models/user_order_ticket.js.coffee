Admin.UserOrderTicket = DS.Model.extend
  concession: DS.attr('boolean')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  redeemedAt: DS.attr('date')
  userOrderId: DS.attr('number')
  member: DS.belongsTo('member', {inverse: 'tickets'})
  type: DS.belongsTo('ticket_type')

  redeemable: (->
    !@get("redeemedAt")
  ).property("redeemedAt")

  redeemed: (->
    @get("redeemedAt")
  ).property("redeemedAt")

  name: (->
    "#{@get("type.set.name")} - #{@get("type.name")}"
  ).property("type.name", "type.set.name")

  price: (->
    if @get("type.concessionPrice")? && @get("concession")
      return @get("type.concessionPrice")
    else
      return @get("type.price")
  ).property("type.price", "type.concessionPrice", "concession")
