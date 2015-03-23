#= require jquery
#= require jquery_ujs
#= require ember-template-compiler
#= require ember
#= require ember-data
#= require_self
#= require admin/admin

# for more details see: http://emberjs.com/guides/application/
window.Admin = Ember.Application.create
  LOG_TRANSITIONS: true
  LOG_TRANSITIONS_INTERNAL: true
  LOG_VIEW_LOOKUPS: true
  rootElement: '#admin-app'
  Resolver: Ember.DefaultResolver.extend
    resolveTemplate: (parsedName) ->
      console.log("Resolving Template:")
      console.log(parsedName)
      parsedName.fullNameWithoutType = "admin/" + parsedName.fullNameWithoutType
      return @_super(parsedName)
