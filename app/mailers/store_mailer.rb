class StoreMailer < ActionMailer::Base
  default :from => "tickets-2012@swancon.com.au"

	def invoice(order)
		@order = order
		mail(:to => order.user.email, :subject => "Invoice #{order.invoice_number}")
	end
	
	def receipt(payment)
		@payment = payment
		mail(:to => payment.user_order.user.email, :subject => "Receipt #{payment.receipt_number}")
	end
end
