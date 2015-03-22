Admin.CheckDetailsController = Ember.ArrayController.extend
  searchName: ""
  searchDisabled: (->
    @get("searchName").length < 3
  ).property("searchName")

  searching: false
  searched: false

  viewMember: null

  actions:
    search: ->
      if @get("searchDisabled")
        return
      self = this
      promiseArray = @store.find('member', {name: @get("searchName")})
      promiseArray.then ->
        self.setProperties
          searching: false
          searched: true
          model: promiseArray.content
      
      @setProperties
        searching: true
        model: null

    showMember: (member)->
      @set('viewMember', member)
