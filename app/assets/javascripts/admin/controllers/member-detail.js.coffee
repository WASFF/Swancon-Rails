Admin.MemberDetailController = Ember.Controller.extend
  title: (->
    member = @get("model")
    if member?
      if member.get("isNew")
        "Creating New Member"
      else
        "Editing: #{member.get("nameReal")}"
    else
      "Unknown Member"
  ).property("model", "model.nameReal")
