Admin.FrontDeskController = Ember.ArrayController.extend
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
      promiseArray = @store.find('member', {name: @get("searchName"), include_tickets: true})
      promiseArray.then ->
        self.setProperties
          searching: false
          searched: true
          model: promiseArray.content
      
      @setProperties
        searching: true
        model: null

    showMember: (member)->
      @send 'showModal', 'member-detail', member

    createMember: ->
      @send 'showModal', 'member-detail', @store.createRecord('member')

    showTickets: (member) ->
      @transitionToRoute('member_tickets', {member_id: member.id})
