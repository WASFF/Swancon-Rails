Admin.TicketSet = DS.Model.extend
  name: DS.attr('string')
  requiresExtendedDetails: DS.attr('boolean') 
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  tickets: DS.hasMany('ticket_type')
