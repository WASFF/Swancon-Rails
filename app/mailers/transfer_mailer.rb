class TransferMailer < ActionMailer::Base
  default from: "Swancon #{Rails.application.config.swancon_year} Memberships <memberships-#{Rails.application.config.swancon_year}@swancon.com.au>", return_path: "memberships-#{Rails.application.config.swancon_year}@swancon.com.au"
  add_template_helper(ApplicationHelper)
  
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
		mail(to: "memberships-#{Rails.application.config.swancon_year}@swancon.com.au", subject: "Ticket Transfer #{transfer.id} started.")
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
		mail(to: "memberships-#{Rails.application.config.swancon_year}@swancon.com.au", subject: "Ticket Transfer #{transfer.id} completed.")
	end
end
