class Validators
  @phone: (string) ->
    unless string? && string.length > 0
      return true
    matchString = string.match(/[\d|\s|(|)|\-|_]+/)
    if matchString?
      return string.length == matchString[0].length
    false

  @email: (string) ->
    unless string? && string.length > 0
      return true
    index = string.indexOf("@")
    atpresent = (index != -1) && (index < string.length - 1)
    index = string.indexOf(" ")
    spacepresent = (index != -1) && (index < string.length - 1)
    return atpresent and !spacepresent

  @notBlank: (string) ->
    string? && string.length > 0

  @blank: (string) ->
    !@notBlank(string)

  @integer: (string) ->
    matchString = string.match(/[\d|\s|]+/)
    if matchString?
      return string.length == matchString[0].length
    false

  @abn: (string) ->
    unless @integer(string)
      false
    else
      string.replace(/\s/g, '').length == 11

  @acn: (string) ->
    unless @integer(string)
      false
    else
      string.replace(/\s/g, '').length == 9

  @decimal: (string) ->
    matchString = string.match(/[\d|\s|.]+/)
    if matchString?
      return string.length == matchString[0].length
    false

  @bsb: (string) ->
    matchString = string.match(/[\d]{3}-[\d]{3}/)
    if matchString?
      return string.length == matchString[0].length
    false

Admin.Validators = Validators
