class UserOrdersController < ApplicationController
	before_filter :authorize_path!
	
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
    if @order.user != current_user and @order.operator != current_user and !current_user.role_symbols.include?(:committee)
    	redirect_to action: :index, controller: :store
    	return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

	def remail
		@order = UserOrder.find(params[:id])
		
		if @order.payment == nil
			StoreMailer.invoice(@order).deliver
		else
			StoreMailer.receipt(@order.payment).deliver
		end
		
		render :show
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

	def unvoid
		@order = UserOrder.find(params[:id])
		if !current_user.role_symbols.include?(:admin) and @order.user != current_user
			flash[:error] = "Don't try to unvoid other people's orders!"
		else
			@order.voided_by = nil
			@order.save
			flash[:notice] = "Your order has been un-voided"
		end

		respond_to do |format|
			format.html { redirect_to(orders_url) }
			format.xml  { head :ok }
		end
	end

	def void
		@order = UserOrder.find(params[:id])
			if !current_user.role_symbols.include?(:admin) and @order.user != current_user
			flash[:error] = "Don't try to void other people's orders!"
		else
			if @order.voidable?
				@order.voided_by = current_user
				@order.save
				flash[:notice] = "Your order has been voided"
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
