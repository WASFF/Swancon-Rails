Admin.MemberDetailController = Ember.Controller.extend
  saving: false

  title: (->
    "Creating New Member" if @get("model.isNew")
    "Editing: #{@get("model.nameReal")}" if @get("model")?
    "Unknown Member"
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
      @set("saving", true)
      self = this
      @get("model").save().then(->
        self.send("removeModal")
        self.set("saving", false)
      , ->
        alert("Unable to save!")
        self.set("saving", false)
      )

    cancel: ->
      @get("model").rollback()
      @send("removeModal")
