class UserOrderTicket < ActiveRecord::Base
	belongs_to :user
	belongs_to :ticket_type
	belongs_to :user_order

	scope :paid, lambda {
		joins(:user_order).where(UserOrder.paidarel)
	}
	
	scope :unpaid, lambda {
		joins(:user_order).where(UserOrder.unpaidarel)
	}	

	def price
		ticket_type.price
	end
end
