Admin.MerchandiseSet = DS.Model.extend
  name: DS.attr('string')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  merchandise: DS.hasMany('merchandise_type')
