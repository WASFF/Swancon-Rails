Ember.Handlebars.helper 'render-boolean', (value) -> 
  unless typeof(value) == "boolean"
    "invalid type"
   return "Yes" if value
   "No"
