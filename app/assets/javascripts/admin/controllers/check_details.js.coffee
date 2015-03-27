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
        if promiseArray.get("length") == 1
          self.send('showMember', promiseArray.get("firstObject"))
      
      @setProperties
        searching: true
        model: null

    showMember: (member)->
      @send 'showModal', 'member-detail', member

    createMember: ->
      @send 'showModal', 'member-detail', @store.createRecord('member')
