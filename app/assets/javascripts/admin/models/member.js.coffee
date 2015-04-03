Admin.Member = DS.Model.extend
  nameBadge: DS.attr('string')
  nameFirst: DS.attr('string')
  nameFirstValidator: ( ->
    return unless @get("isDirty")
    nameFirst = @get("nameFirst")
    errors = @get("errors") 
    errors.remove("nameFirst")

    unless nameFirst.length > 1
      errors.add("nameFirst", "must have more than one character")

  ).observes("nameFirst")

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
  usernameValidator: ( ->
    return unless @get("isDirty")
    username = @get("username")
    errors = @get("errors") 
    errors.remove("username")

    unless username.length > 3
      errors.add("username", "must be at least 3 characters")

  ).observes("username")
  
  email: DS.attr('string')
  emailValidator: ( ->
    return unless @get("isDirty")
    email = @get("email")
    errors = @get("errors") 
    errors.remove("email")
    unless Admin.Validators.notBlank(email)
      return
    unless Admin.Validators.email(email)
      errors.add("email", "must be a valid email address")

  ).observes("email")

  phone: DS.attr('string')
  
  address_1: DS.attr('string')
  address_1Validator: ( ->
    return unless @get("isDirty")
    address_1 = @get("address_1")
    errors = @get("errors") 
    errors.remove("address_1")
    unless address_1.length > 1
      errors.add("address_1", "must have at more than one character")
  ).observes("address_1")

  address_2: DS.attr('string')
  address_3: DS.attr('string')
  address_3Validator: ( ->
    return unless @get("isDirty")
    address_3 = @get("address_3")
    errors = @get("errors") 
    errors.remove("address_3")
    unless address_3.length > 2
      errors.add("address_3", "must have at more than two characters")
  ).observes("address_3")

  addressState: DS.attr('string')
  stateValidator: ( ->
    return unless @get("isDirty")
    addressState = @get("addressState")
    errors = @get("errors") 
    errors.remove("addressState")
    unless addressState.length > 1
      errors.add("addressState", "must have at more than one character")

  ).observes("addressState")

  addressPostcode: DS.attr('string')
  postcodeValidator: ( ->
    return unless @get("isDirty")
    addressPostcode = @get("addressPostcode")
    errors = @get("errors") 
    errors.remove("addressPostcode")
    unless addressPostcode.length > 3
      errors.add("addressPostcode", "must have at more than three characters")

  ).observes("addressPostcode")

  addressCountry: DS.attr('string')
  
  disclaimerSigned: DS.attr('boolean')

  emailOptin: DS.attr('boolean')
  tickets: DS.hasMany('user_order_ticket')
