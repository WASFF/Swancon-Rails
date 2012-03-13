class TransferMailer < ActionMailer::Base
  default from: "Doom-Con: Swancon 2012 Memberships <memberships-2012@swancon.com.au>", return_path: 'memberships-2012@swancon.com.au'
	helper :application, Authorization::AuthorizationHelper

	def reconfirm_sender(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer
		mail(to: transfer.previous_owner.email, :subject => "A Ticket transfer has been requested.}")
	end

	def reconfirm_recipient(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer
		mail(to: transfer.recipient.email, :subject => "Ticket transfer to you has begun!}")
	end

	def reconfirm_admin(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer
		mail(to: "memberships-2012@swancon.com.au", subject: "Ticket Transfer #{transfer.id} started.")
	end

	def cancel_sender(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(to: transfer.previous_owner.email, :subject => "Your ticket transfer has been cancelled.}")
	end

	def cancel_recipient(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(to: transfer.recipient.email, :subject => "Ticket Transfer to you has been cancelled.}")
	end

	def cancel_admin(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(to: transfer.previous_owner.email, :subject => "Ticket Transfer #{transfer.id} started")
	end

	def completed_sender(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(to: transfer.previous_owner.email, :subject => "Your ticket has now been transferred to the recipient.}")
	end

	def completed_recipient(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(to: transfer.recipient.email, :subject => "Ticket transfer to you has finished!}")
	end
	
	def completed_admin(transfer)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer
		mail(to: "memberships-2012@swancon.com.au", subject: "Ticket Transfer #{transfer.id} completed.")
	end

	def permitted_to?(*args)
		false
	end
end
