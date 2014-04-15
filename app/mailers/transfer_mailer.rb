class TransferMailer < BaseMailer
  default from: "Swancon #{Rails.application.config.swancon_year} Memberships <memberships-#{Rails.application.config.swancon_year}@swancon.com.au>", return_path: "memberships-#{Rails.application.config.swancon_year}@swancon.com.au"
  
	def reconfirm_sender(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer
		mail(
			to: transfer.previous_owner.email,
			current_user: current_user,
			subject: "A Ticket transfer has been requested."
		)
	end

	def reconfirm_recipient(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer
		mail(
			to: transfer.recipient.email,
			current_user: current_user,
			subject: "Ticket transfer to you has begun!"
		)
	end

	def reconfirm_admin(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer
		mail(
			to: "memberships-#{Rails.application.config.swancon_year}@swancon.com.au",
			current_user: current_user,
			subject: "Ticket Transfer #{transfer.id} started."
		)
	end

	def cancel_sender(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(
			to: transfer.previous_owner.email,
			current_user: current_user,
			subject: "Your ticket transfer has been cancelled."
		)
	end

	def cancel_recipient(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(
			to: transfer.recipient.email,
			current_user: current_user,
			subject: "Ticket Transfer to you has been cancelled."
		)
	end

	def cancel_admin(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(
			to: transfer.previous_owner.email,
			current_user: current_user,
			subject: "Ticket Transfer #{transfer.id} started"
		)
	end

	def completed_sender(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(
			to: transfer.previous_owner.email,
			current_user: current_user,
			subject: "Your ticket has now been transferred to the recipient."
		)
	end

	def completed_recipient(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer		
		mail(
			to: transfer.recipient.email,
			current_user: current_user,
			subject: "Ticket transfer to you has finished!"
		)
	end
	
	def completed_admin(transfer, current_user = nil)
		@ticket = transfer.ticket
		@recipient = transfer.recipient
		@sender = transfer.sender
		@transfer = transfer
		mail(
			to: "memberships-#{Rails.application.config.swancon_year}@swancon.com.au",
			current_user: current_user,
			subject: "Ticket Transfer #{transfer.id} completed."
		)
	end
end
