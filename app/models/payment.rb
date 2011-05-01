class Payment < ActiveRecord::Base
	belongs_to :payment_type
	has_many :launch_member_merchandise_types
	has_many :launch_member_ticket_types
	has_one :user_order
	
	def receipt_number
		sprintf "DOOMCON-%05d", id
	end
	
	def reciept_number
		sprintf "DOOMCON-%05d", id
	end
	
	def receipt
		sprintf "DOOMCON-%05d", id
	end
	
	def receipt
		sprintf "DOOMCON-%05d", id		
	end
	
	def type
		payment_type
	end
	
	def type=(value)
		self.payment_type = value
	end
end
