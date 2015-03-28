Ember.Handlebars.helper 'render-date', (value, format) -> 
  unless typeof(format) == "string"
    format = "DD/MM/YYYY HH:MM"
  return moment(value).format(format) if value?
  return "n/a"
