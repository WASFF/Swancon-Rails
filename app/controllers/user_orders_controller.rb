class UserOrdersController < ApplicationController  
  # GET /payment_types
  # GET /payment_types.xml
  def index
    authorize_path!

    @allorders = false
    @orders = UserOrder.includes(:user_order_merchandise).includes(:user_order_tickets)
    unless user_can?(:view_all, UserOrder) and params[:all] == "true"
      @orders = @orders.for_user(current_user).unvoid
    else
      @allorders = true
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
    unless user_can? :show?, @order 
      redirect_to orders_path
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  def remail
    @order = UserOrder.find(params[:id])

    unless user_can? :remail?, @order 
      redirect_to orders_path
      return
    end    

    if @order.payment == nil
      StoreMailer.invoice(@order, current_user).deliver
    else
      StoreMailer.receipt(@order.payment, current_user).deliver
    end
    
    render :show
  end

  def mark_paid
    @order = UserOrder.find(params[:id])
    
    unless user_can? :mark_paid?, @order 
      redirect_to orders_path
      return
    end    
    
    payment = Payment.new(:user_order => @order, :payment_type => @order.payment_type)
    payment.amount = params[:user_order][:amount]
    payment.verification_string = params[:user_order][:verification_string]
    payment.operator = current_user
    payment.save

    StoreMailer.receipt(payment, current_user).deliver    
    render :action => :show
  end

  def unvoid
    @order = UserOrder.find(params[:id])

    unless user_can? :void?, @order 
      flash[:error] = "Don't try to unvoid other people's orders!"
    else
      @order.voided_by = nil
      @order.save
      flash[:notice] = "Your order has been un-voided"
    end

    respond_to do |format|
      format.html { redirect_to(orders_url(all: true)) }
      format.xml  { head :ok }
    end
  end

  def void
    @order = UserOrder.find(params[:id])

    unless user_can? :void?, @order 
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
      format.html { redirect_to(orders_url(all: true)) }
      format.xml  { head :ok }
    end
  end
end
