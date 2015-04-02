Admin.ApplicationRoute = Ember.Route.extend
  actions:
    showModal: (name, model) ->
      @render name, 
        into: 'application'
        outlet: 'modal'
        model: model

    removeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'
