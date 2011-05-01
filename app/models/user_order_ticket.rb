class UserOrderTicket < ActiveRecord::Base
	belongs_to :user
	belongs_to :ticket_type
	belongs_to :user_order

	def price
		ticket_type.price
	end

end
