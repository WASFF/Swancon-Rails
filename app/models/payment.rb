class Payment < ActiveRecord::Base
	belongs_to :payment_type
	
	def type
		payment_type
	end
	
	def type=(value)
		self.payment_type = value
	end
end
