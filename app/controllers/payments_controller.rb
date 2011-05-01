class PaymentsController < ApplicationController
	filter_resource_access
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /payment_types/1
  # GET /payment_types/1.xml
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

	def void
		payment = Payment.find(params[:id])
		order = payment.user_order
		order.payment = nil
		order.save
		
		redirect_to order_url(order)		
	end
end
