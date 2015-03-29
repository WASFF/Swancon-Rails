Admin.UserOrderMerchandise = DS.Model.extend
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  userOrderId: DS.attr('number')
#  member: DS.belongsTo('member', {inverse: 'tickets'})
  type: DS.belongsTo('merchandise_type')
  options: DS.hasMany('user_order_merchandise_option')

  name: (->
    "#{@get("type.set.name")} - #{@get("type.name")}"
  ).property("type.name", "type.set.name")

  price: (->
    return @get("type.price")
  ).property("type.price")

  optionsString: (->
    value = ""
    @get("options").forEach (item) ->
      value += " #{item.get("option.name")} "
    value
  ).property("options.@each")
