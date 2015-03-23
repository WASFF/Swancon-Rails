Admin.ApplicationRoute = Ember.Route.extend
  actions:
    showModal: (name, modal) ->
      @render name, 
        into: 'application'
        outlet: 'modal'
        model: model

    removeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'
