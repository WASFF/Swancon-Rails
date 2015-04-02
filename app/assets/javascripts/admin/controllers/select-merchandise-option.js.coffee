Admin.SelectMerchandiseOptionController = Ember.Controller.extend
  needs: "store"
  title: (->
    "Select options for #{@get("model.name")}"
  ).property("model.name")

  disableAddCart: true

  actions:
    updateOptionForSet: (type, set, option) ->
      unless @selectedOptions?
        @selectedOptions = {}
      unless option?
        @selectedOptions[set.get("id")] = null
      else
        @selectedOptions[set.get("id")] = option
    
      disable = false
      @get("model.option_sets").forEach (set) =>
        if disable
          return
        unless @selectedOptions[set.get("id")]?
          disable = true
      @set("disableAddCart", disable)

    addToCart: ->
      @get("controllers.store").send("addMerchandiseWithOptions", @get("model"), @selectedOptions)
      @send("removeModal")
      
    cancel: ->
      @send("removeModal")
