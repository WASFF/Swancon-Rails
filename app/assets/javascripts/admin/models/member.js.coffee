Admin.Member = DS.Model.extend
  name_badge: DS.attr('string')
  name_first: DS.attr('string')
  name_last: DS.attr('string')
  name_real: (->
    string = null
    name_first = @get("name_first")
    name_last = @get("name_last")
    if name_first?
      string = "#{name_first}"
    if name_last?
      string += " #{name_last}" if string?
      string = "#{name_last}" unless string?

    if string?
      string
    else
      "No Name Entered!"
  ).property("name_first", "name_last")
  
  username: DS.attr('string')
  
  email: DS.attr('string')
  phone: DS.attr('string')
  
  address_1: DS.attr('string')
  address_2: DS.attr('string')
  address_3: DS.attr('string')
  address_state: DS.attr('string')
  address_postcode: DS.attr('string')
  address_country: DS.attr('string')
  
  disclaimer_signed: DS.attr('boolean')
  email_optin: DS.attr('boolean')
