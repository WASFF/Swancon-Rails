Admin.SelectForMerchandiseOptionsComponent = Ember.Component.extend
  type: null
  set: null

  canDisplay: (->
    @get("type")? && @get("set")?
  ).property("type", "set")

  setOptions: (->
    options = []
    set_id = @get("set.id")
    @get("type.options").forEach (item) ->
      if item.get("set.id") == set_id
        options.addObject(item)

    options
  ).property("type", "set", "type.options")

  didInsertElement: ->
    $select = @$('select')
    $select.on 'change', (event) =>
      option_id = $select.find('option:selected').attr('id')
      type = @get("type")
      option = null
      type.get("options").forEach (item) ->
        if item.get("id") == option_id
          option = item
      if type? && option?
        @sendAction('action', type, @get("set"), option)
      else
        @sendAction('action', type, @get("set"), null)

