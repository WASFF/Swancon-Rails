Admin.Member = DS.Model.extend
  nameBadge: DS.attr('string')
  nameFirst: DS.attr('string')
  nameLast: DS.attr('string')
  nameReal: (->
    string = null
    nameFirst = @get("nameFirst")
    nameLast = @get("nameLast")
    if nameFirst?
      string = "#{nameFirst}"
    if nameLast?
      string += " #{nameLast}" if string?
      string = "#{nameLast}" unless string?

    if string?
      string
    else
      "No Name Entered!"
  ).property("nameFirst", "nameLast")
  
  username: DS.attr('string')
  
  email: DS.attr('string')
  phone: DS.attr('string')
  
  address_1: DS.attr('string')
  address_2: DS.attr('string')
  address_3: DS.attr('string')
  addressState: DS.attr('string')
  addressPostcode: DS.attr('string')
  addressCountry: DS.attr('string')
  
  disclaimerSigned: DS.attr('boolean')
  emailOptin: DS.attr('boolean')
