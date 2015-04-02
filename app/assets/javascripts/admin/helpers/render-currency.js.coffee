Ember.Handlebars.helper 'render-currency', (value, symbol) -> 
  unless typeof(symbol) == "string"
    symbol = "$"
  unless typeof(value) == "number"
    "invalid type"
  negative = value < 0
  if negative
    value = value * -1
  cents = Math.round((value * 100) % 100)
  if cents < 10 
    cents = "0#{cents}"
  dollars = "#{Math.floor(value)}"
  dollars = dollars.replace(/\B(?=(\d{3})+(?!\d))/g, ",")

  if negative
    "-#{symbol}#{dollars}.#{cents}"
  else
    "#{symbol}#{dollars}.#{cents}"

