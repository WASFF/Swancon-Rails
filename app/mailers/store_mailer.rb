class StoreMailer < BaseMailer
	default from: "Swancon #{Rails.application.config.swancon_year} Store/Tickets <tickets-#{Rails.application.config.swancon_year}@swancon.com.au>", return_path: "tickets-#{Rails.application.config.swancon_year}@swancon.com.au"

	def invoice(order, current_user = nil)
		@order = order
		@email = true
		mail(
			:to => order.user.email,
			current_user: current_user,
			:subject => "Invoice #{order.invoice_number}"
		)
	end
	
	def receipt(payment, current_user = nil)
		@payment = payment
		@email = true
		mail(
			:to => payment.user_order.user.email,
			current_user: current_user,
			subject: "Receipt #{payment.receipt_number}"
		)
	end

	def ticket_sold(payment, current_user = nil)
		@payment = payment
		@email = true
		mail(
			to: "memberships-#{Rails.application.config.swancon_year}@swancon.com.au",
			subject: "New Payment Recieved: #{payment.receipt_number} for Order: #{order.invoice_number}",
			current_user: current_user
		)
	end

	def confirmation_required(order, current_user = nil)
		@order = order
		@email = true
		mail(
			to: "memberships-#{Rails.application.config.swancon_year}@swancon.com.au",
			subject: "New Order Recieved: #{order.invoice_number} - requires Confirmation",
			current_user: current_user
		)
	end

	def tshirtconfirm(user, shirtorders, orders, current_user = nil)
		@user = user
		@detail = user.member_detail
		@shirtorders = shirtorders
		@orders = orders
		@email = true		
		#mail(:to => user.email, :subject => "Confirming your t-shirt size")
		subject = "Swancon T-Shirt Order"
		@orders.each do |order|
			if order.payment != nil
				subject += " [#{order.payment.receipt_number}]"
			end
		end
		mail(
			to: user.email,
			subject: subject,
			 current_user: current_user
		)
	end

	def user_can_visit?(*args)
		false
	end

	def user_can?(*args)
		false
	end
end
