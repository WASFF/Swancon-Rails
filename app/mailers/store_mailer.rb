class StoreMailer < ActionMailer::Base
  default :from => "tickets-2012@swancon.com.au"
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

	def tshirtconfirm(user, shirtorders)
		@user = user
		@detail = user.member_detail
		@shirtorders = shirtorders
		@email = true		
		#mail(:to => user.email, :subject => "Confirming your t-shirt size")
		mail(:to => "lordmortis@gmail.com", :subject => "Confirming your t-shirt size")
	end
	
	def permitted_to?(*args)
		false
	end
end
