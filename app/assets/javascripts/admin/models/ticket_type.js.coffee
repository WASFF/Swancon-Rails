Admin.TicketType = DS.Model.extend
  name: DS.attr('string')
  description: DS.attr('string') 
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  price: DS.attr('number')
  concessionPrice: DS.attr('number')
  set: DS.belongsTo('ticket_set')
