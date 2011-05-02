class StoreController < ApplicationController
	before_filter :init_cart

	def index
		@ticketsets = TicketSet.available.all
		@merchsets = MerchandiseSet.available.all
	end
	
	def merchandise
		@merch = MerchandiseType.where(:id => params[:id]).first
		if @merch == nil
			redirect_to :action => :index
			return
		end
	end
	
	def merchandise_add
		options = Array.new
		params[:option_set].keys.each do |option|
			options << params[:option_set][option]
		end
		
		session[:cart][:merch] << {:id => params[:id].to_i, :options => options}
		redirect_to :back
	end
	
	def merchandise_remove
		array = session[:cart][:merch]
		if params[:index].to_i >= 0 and params[:index].to_i < array.size
			array.delete_at(params[:index].to_i)
		end
		redirect_to :back
	end

	def ticket
		@ticket = TicketType.where(:id => params[:id]).first
		if @ticket == nil
			redirect_to :action => :index
			return
		end
	end
	
	def ticket_add
		session[:cart][:tickets] << params[:id].to_i
		redirect_to :back
	end
	
	def ticket_remove
		array = session[:cart][:tickets]
		if params[:index].to_i >= 0 and params[:index].to_i < array.size
			array.delete_at(params[:index].to_i)
		end		
		redirect_to :back
	end
	
	def purchase		
		if @cart[:merch].size == 0 and @cart[:tickets].size == 0
			flash[:notice] = "Please add items to your cart"
			redirect_to :action => :index
			return
		end
		
		if current_user == nil
			flash[:notice] = "Please log in to complete your purchase"
			redirect_to new_user_session_path
			return
		end
		
		
		if params[:confirm] == "true"
			if params[:purchase][:payment_type_id].strip == "" 
				flash[:notice] = "Please select how you'd like to pay."
				return
			end
			
			order = UserOrder.new(:user => current_user, :payment_type_id => params[:purchase][:payment_type_id].to_i)
			order.save
			@cart[:tickets].each do |ticket_id|
				ticket = UserOrderTicket.new(:ticket_type_id => ticket_id, :user_order_id => order.id, :user_id => current_user.id)
				ticket.save
			end
			
			@cart[:merch].each do |merch_hash|
				merch = UserOrderMerchandise.new(:merchandise_type_id => merch_hash[:id], :user_order_id => order.id)
				merch_hash[:options].each do |option_id|
					merch.options << UserOrderMerchandiseOption.new(:merchandise_option_id => option_id)
				end
				
				merch.save
			end
			
			session[:cart] = nil
			@cart = nil
			flash[:notice] = "Order Placed"
			StoreMailer.invoice(order).deliver
			redirect_to order_path(order)
		end
	end
	
	private
	
	def init_cart
		if session[:cart] == nil
			session[:cart] = Hash.new
			session[:cart][:merch] = Array.new
			session[:cart][:tickets] = Array.new
		end
		
		@cart = session[:cart]	
		true		
	end
	
end
