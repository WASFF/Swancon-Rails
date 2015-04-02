Admin.UserOrderMerchandiseOption = DS.Model.extend
  option: DS.belongsTo('merchandise_option')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
