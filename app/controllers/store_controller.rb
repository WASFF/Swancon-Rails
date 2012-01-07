class StoreController < ApplicationController
	before_filter :init_cart, :init_user

	def index
		@ticketsets = TicketSet.available(current_user).all
		@merchsets = MerchandiseSet.available(current_user).all
	end
	
	def clear_cart
		session[:cart] = nil
		@cart = nil
		
		redirect_to :action => :index
	end
		
	def merchandise
		@merch = MerchandiseType.where(:id => params[:id]).first
		if @merch == nil
			redirect_to :action => :index
			return
		end
	end
	
	def merchandise_add
		merch = MerchandiseType.where(:id => params[:id]).first
		if merch.available? or @store_user != nil
			options = Array.new
			params[:option_set].keys.each do |option|
				options << params[:option_set][option]
			end
		
			session[:cart][:merch] << {:id => params[:id].to_i, :options => options}
		end
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
		ticket = TicketType.where(:id => params[:id]).first
		
		if ticket.available? or @store_user != nil
			session[:cart][:tickets] << params[:id].to_i
		end
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
			
			order = UserOrder.new(:payment_type_id => params[:purchase][:payment_type_id].to_i)
			if @store_user != nil
				order.user = @store_user
			else
				order.user = current_user
			end
			
			if @store_user != nil
				order.operator = current_user
			end
			
			order.save
			@cart[:tickets].each do |ticket_id|
				ticket = UserOrderTicket.new(:ticket_type_id => ticket_id, :user_order_id => order.id)
				if @store_user == nil
					 ticket.user_id = current_user.id
				else
					 ticket.user_id = @store_user.id					
				end
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
			session[:store_user_id] = nil
			@cart = nil
			flash[:notice] = "Order Placed, Email Sent"
			if @store_user != nil
				if order.payment_type.available_online
					if params[:send_email] == "true"
						StoreMailer.invoice(order).deliver
						StoreMailer.confirmation_required(order).deliver
					end
				else
					payment = Payment.new(:user_order => order, :payment_type => order.payment_type)
					payment.amount = order.total
					payment.operator = current_user
					payment.verification_string = "Point Of Sale"
					payment.save
					if params[:send_email] == "true"
						StoreMailer.receipt(payment).deliver
					end
					StoreMailer.confirmation_required(order).deliver
					redirect_to payment
					return
				end
			else
				StoreMailer.invoice(order).deliver
				StoreMailer.confirmation_required(order).deliver
			end
			
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
	
	def init_user
		if session[:store_user_id] != nil
			@store_user = User.find(session[:store_user_id])
		end
		true
	end
	
end
