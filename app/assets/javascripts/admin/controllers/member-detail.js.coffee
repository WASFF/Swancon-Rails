Admin.MemberDetailController = Ember.Controller.extend
  saving: false
  showErrors: false

  title: (->
    return "Creating New Member" if @get("model.isNew")
    return "Editing: #{@get("model.nameReal")}" if @get("model")?
    return "Unknown Member"
  ).property("model", "model.nameReal", "model.isNew")

  saveButtonName: (->
    return "Saving..." if @get("saving")
    return "Save New Member" if @get("model.isNew")
    return "Update Member" if @get("model")?
    "Unknown"
  ).property("model", "saving", "model.isNew")

  saveButtonDisabled: (->
    !@get("model.isDirty") || @get("saving")
  ).property("model.isDirty", "saving")

  actions:
    save: ->
      @setProperties
        saving: true
        showErrors: false

      self = this
      @get("model").save().then(->
        self.send("removeModal")
        self.set("saving", false)
      , ->
        self.setProperties
          showErrors: true
          saving: false
      )

    cancel: ->
      @get("model").rollback()
      @send("removeModal")
