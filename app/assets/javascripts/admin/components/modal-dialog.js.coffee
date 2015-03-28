Admin.ModalDialogComponent = Ember.Component.extend
  didInsertElement: ->
    self = this
    @$('.modal').on 'click', (e) ->
      if e.currentTarget == e.target
        self.send("close")
    $("body").addClass("noscroll")

  willDestroyElement: ->
    $("body").removeClass("noscroll")

  actions:
    close: ->
      @sendAction()
