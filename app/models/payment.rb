class Payment < ActiveRecord::Base
	belongs_to :payment_type
	belongs_to :operator, :class_name => "User"	
	has_many :launch_member_merchandise_types
	has_many :launch_member_ticket_types
	has_one :user_order
	belongs_to :voiding_user, :class_name => "User"
	
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
	
	def void(user)
		self.voiding_user = user
		self.voided_at = Time.now
		self.user_order = nil
		self.save
	end
	
	def isvoid?
		self.voiding_user != nil or self.voided_at != nil
	end
end
