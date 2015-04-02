Admin.MerchandiseType = DS.Model.extend
  name: DS.attr('string')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  price: DS.attr('number')
  set: DS.belongsTo('merchandise_set')
  option_sets: DS.hasMany('merchandise_option_set')
  options: DS.hasMany('merchandise_option')
