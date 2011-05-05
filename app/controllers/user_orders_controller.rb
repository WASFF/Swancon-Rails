class UserOrdersController < ApplicationController
	filter_resource_access :additional_member => [:mark_paid, :remail]
  # GET /payment_types
  # GET /payment_types.xml
  def index
		@allorders = false
		if params[:all] == "true" and current_user.role_symbols.include?(:admin)
    	@orders = UserOrder.includes(:user_order_merchandise).includes(:user_order_tickets).all
			@allorders = true
		else
			@orders = UserOrder.where(:user_id => current_user.id).includes(:user_order_merchandise).includes(:user_order_tickets).all
		end
		
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /payment_types/1
  # GET /payment_types/1.xml
  def show
    @order = UserOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

	def remail
		@order = UserOrder.find(params[:id])
		
		if @order.payment == nil
			StoreMailer.invoice(order).deliver
		else
			StoreMailer.receipt(order.payment).deliver
		end
		
		redirect_to :action => "show"
	end

	def mark_paid
		if !current_user.role_symbols.include?(:admin)
			redirect_to orders_path
			return
		end
		@order = UserOrder.find(params[:id])
		
		payment = Payment.new(:user_order => @order, :payment_type => @order.payment_type)
		payment.amount = params[:user_order][:amount]
		payment.verification_string = params[:user_order][:verification_string]
		payment.operator = current_user
		payment.save

		StoreMailer.receipt(payment).deliver		
		render :action => :show
	end

  # DELETE /payment_types/1
  # DELETE /payment_types/1.xml
  def destroy
    @order = UserOrder.find(params[:id])
		if !current_user.role_symbols.include?(:admin) and @order.user != current_user
			flash[:error] = "Don't try to remove other people's orders!"
		else
			if @order.payment == nil
				@order.destroy
				flash[:notice] = "Your order has been removed"
			else
	    	flash[:error] = "You cannot remove an order you've paid for!"
			end
		end

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
