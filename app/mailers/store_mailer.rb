class StoreMailer < ActionMailer::Base
  default from: "Swancon #{Rails.application.config.swancon_year} Store/Tickets <#{Rails.application.config.swancon_year}@swancon.com.au>", return_path: "tickets-#{Rails.application.config.swancon_year}@swancon.com.au"
	helper :application, Authorization::AuthorizationHelper

	def invoice(order)
		@order = order
		@email = true
		mail(:to => order.user.email, :subject => "Invoice #{order.invoice_number}")
	end
	
	def receipt(payment)
		@payment = payment
		@email = true
		mail(:to => payment.user_order.user.email, :subject => "Receipt #{payment.receipt_number}")
	end

	def confirmation_required(order)
		@order = order
		@email = true
		mail(:to => "memberships-#{Rails.application.config.swancon_year}@swancon.com.au", :subject => "New Order Recieved: #{order.invoice_number}")
	end

	def tshirtconfirm(user, shirtorders, orders)
		@user = user
		@detail = user.member_detail
		@shirtorders = shirtorders
		@orders = orders
		@email = true		
		#mail(:to => user.email, :subject => "Confirming your t-shirt size")
		subject = "Swancon T-Shirt Order"
		@orders.each do |order|
			if order.payment != nil
				subject += " [#{order.payment.reciept_number}]"
			end
		end
		mail(:to => user.email, :subject => subject)
	end
	
	def permitted_to?(*args)
		false
	end
end
