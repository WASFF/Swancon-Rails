Admin.MerchandiseOption = DS.Model.extend
  name: DS.attr('string')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  set: DS.belongsTo('merchandise_option_set')
