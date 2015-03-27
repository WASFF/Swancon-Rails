Admin.ModalDialogComponent = Ember.Component.extend
  didInsertElement: ->
    self = this
    @$('.modal').on 'click', (e) ->
      if e.currentTarget == e.target
        self.send("close")

  actions:
    close: ->
      @sendAction()
