class StoreController < ApplicationController
	before_filter :init_cart, :init_user, :prepare_backlink

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
			if params.has_key? :option_set
				params[:option_set].keys.each do |option|
					options << params[:option_set][option]
				end
			end
		
			session[:cart][:merch] << {:id => params[:id].to_i, :options => options}
		end
		if request.env.include?("HTTP_REFERER")
			redirect_to :back
		else
			redirect_to action: :merchandise, id: merch.id
		end
	end
	
	def merchandise_remove
		array = session[:cart][:merch]
		if params[:index].to_i >= 0 and params[:index].to_i < array.size
			array.delete_at(params[:index].to_i)
		end
		if request.env.include?("HTTP_REFERER")
			redirect_to :back
		else
			redirect_to action: :index
		end
	end

	def ticket
#		@title = 
		@ticket = TicketType.where(:id => params[:id]).first
		if @ticket == nil
			redirect_to :action => :index
			return
		end
	end
	
	def ticket_add
		ticket = TicketType.where(:id => params[:id]).first
		
		if ticket.available? or @store_user != nil
			if params[:concession].present? and params[:concession][:value] == "true"
				session[:cart][:concessions] << params[:id].to_i				
			else
				session[:cart][:tickets] << params[:id].to_i
			end
		end
		if request.env.include?("HTTP_REFERER")
			redirect_to :back
		else
			redirect_to action: :ticket, id: ticket.id
		end
	end
	
	def ticket_remove
		array = []
		if params[:concessions] == "true"
			array = session[:cart][:concessions]
		else
			array = session[:cart][:tickets]
		end
		if params[:index].to_i >= 0 and params[:index].to_i < array.size
			array.delete_at(params[:index].to_i)
		end		
		if request.env.include?("HTTP_REFERER")
			redirect_to :back
		else
			redirect_to action: :index
		end
	end
	
	def purchase		
		if @cart[:merch].size == 0 and @cart[:tickets].size == 0 and @cart[:concessions].size == 0
			flash[:notice] = "Please add items to your cart"
			redirect_to :action => :index
			return
		end
		
		if current_user == nil
			flash[:notice] = "Please log in to complete your purchase"
			redirect_to new_user_session_path
			return
		end
		
		@payment_types = PaymentType.online_types
		@can_disable_email = false

		if user_can_visit?(:seller, :index) && @store_user.present?
			if current_user.role_symbols.include?(:committee) or current_user.role_symbols.include?(:admin) 
				if SiteSettings.con_mode
					@payment_types = PaymentType.con_types
				else
					@payment_types = PaymentType.all
				end
				@can_disable_email = true
			else
				@payment_types = PaymentType.reseller_types
			end
		end
		
		if params[:confirm] == "true"
			if params[:purchase][:payment_type_id].strip == "" 
				flash[:notice] = "Please select how you'd like to pay."
				return
			end

			order = UserOrder.new(:payment_type_id => params[:purchase][:payment_type_id].to_i)

			if !(@payment_types.include?(order.payment_type))
				flash[:notice] = "Please select how you'd like to pay."
				return
			end

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

			@cart[:concessions].each do |ticket_id|
				ticket = UserOrderTicket.new(:ticket_type_id => ticket_id, :user_order_id => order.id, concession: true)
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
			flash[:notice] = "Order Placed"
			if @store_user != nil
				if order.payment_type.requires_reconciliation
					if params[:send_email] == "true" or !@can_disable_email
						if order.user.email_valid
							StoreMailer.invoice(order, current_user).deliver
							StoreMailer.confirmation_required(order, current_user).deliver
							flash[:notice] += ", Email Sent"
						else
							flash[:notice] += ", User has no email address. Ensure they take their reciept print out (print this page)!"
						end
					end
				else
					payment = Payment.new(:user_order => order, :payment_type => order.payment_type)
					payment.amount = order.total
					payment.operator = current_user
					payment.verification_string = "Point Of Sale"
					payment.save
					if params[:send_email] == "true"
						StoreMailer.receipt(payment, current_user).deliver
					end
					StoreMailer.confirmation_required(order, current_user).deliver
					redirect_to payment
					return
				end
			else
				StoreMailer.invoice(order, current_user).deliver
				StoreMailer.confirmation_required(order, current_user).deliver
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
			session[:cart][:concessions] = Array.new
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
