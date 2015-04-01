Admin.MemberDetailController = Ember.Controller.extend
  saving: false

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
    return true if @get("saving")
    return true unless @get("model.isDirty")
    return true unless @get("model.errors.length") == 0
    return true unless @get("model.disclaimerSigned")
    return false
  ).property("model.isDirty", "saving", "model.errors.length", "model.disclaimerSigned")

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
          saving: false
      )

    cancel: ->
      @get("model").rollback()
      @send("removeModal")
