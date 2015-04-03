Admin.PurchaseCompleteController = Ember.Controller.extend
  title: ( ->
    return "title"
  ).property("model")

  paymentUrl: (->
    "/payments/#{@get("model.paymentId")}"
  ).property("model.paymentId")

  orderUrl: (->
    "/orders/#{@get("model.userOrderId")}"
  ).property("model.userOrderId")

  actions:
    complete: ->
      @transitionToRoute('front_desk')
      @send('removeModal')
