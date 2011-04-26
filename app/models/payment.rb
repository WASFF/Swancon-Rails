class Payment < ActiveRecord::Base
	belongs_to :payment_type
	has_many :launch_member_merchandise_types
	has_many :launch_member_ticket_types
	
	def type
		payment_type
	end
	
	def type=(value)
		self.payment_type = value
	end
end
