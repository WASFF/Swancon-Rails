class UserOrderTicketTransfer < ActiveRecord::Base
	belongs_to :user_order_ticket
	belongs_to :sender, class_name: "User"
	belongs_to :previous_owner, class_name: "User"
	belongs_to :recipient, class_name: "User"

	def ticket
		user_order_ticket
	end

	def ticket=(value)
		self.user_order_ticket = value
	end

	def confirm
		self.confirmed_on = DateTime.now
		ticket.user = recipient
		ticket.save
		self.save
	end

	def can_cancel?(user)
		if user == nil
			false
		elsif user.class != User
			false
		elsif user.role_symbols.include?(:admin)
			true
		else
			false
		end
	end
end
