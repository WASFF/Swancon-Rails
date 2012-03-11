class UserOrderTicket < ActiveRecord::Base
	belongs_to :user
	belongs_to :ticket_type
	belongs_to :user_order
	has_many :user_order_ticket_transfers

	scope :paid, lambda {
		joins(:user_order).where(UserOrder.paidarel)
	}
	
	scope :unpaid, lambda {
		joins(:user_order).where(UserOrder.unpaidarel)
	}	

	def type
		ticket_type
	end

	def price
		ticket_type.price
	end

	def isvoid?
		user_order.is_void?
	end

	def payment_verified?
		user_order.payment_id != nil
	end

	def can_transfer?(user)
		# FIXME: shouldn't be able to transfer if a transfer is pending.
		if user_order.payment_id == nil
			false
		elsif user == nil
			false
		elsif user.class != User
			false
		elsif user == self.user
			true
		elsif user.role_symbols.include?(:admin)
			true
		else
			false
		end
	end

	def requires_extended_details
		ticket_type.requires_extended_details
	end

	def transfer(sender, newowner)
		transfer = UserOrderTicketTransfer.new
		transfer.ticket = self
		transfer.recipient = newowner
		transfer.sender = sender
		transfer.previous_owner = self.user
		transfer.confirmation_code = Digest::MD5.hexdigest(DateTime.now.to_s + newowner.display_name + sender.display_name + self.user.display_name)
		transfer.save

		transfer
	end
end
