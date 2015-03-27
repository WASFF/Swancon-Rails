class UserOrder < ActiveRecord::Base
	belongs_to :user
	belongs_to :operator, :class_name => "User"
	has_many :user_order_merchandise, :dependent => :destroy
	has_many :user_order_tickets, :dependent => :destroy
	belongs_to :payment
	belongs_to :payment_type
	belongs_to :voided_by, :class_name => "User"

	scope :paid, lambda {
		where(self.paidarel)
	}

	def invoice_number
		sprintf "2016-ORDER-%05d", id
	end
	
	def invoice
		sprintf "2016-ORDER-%05d", id		
	end
	
	def short_invoice
		sprintf "2016%05d", id		
	end
	
	def short_invoice_number
		sprintf "2016%05d", id
	end

	def merchandise
		user_order_merchandise
	end
	
	def tickets
		user_order_tickets
	end
	
	def subtotal
		total = 0.0
		merchandise.each do |merch|
			total += merch.price
		end
		
		tickets.each do |ticket|
			if ticket.concession
				total += ticket.concession_price
			else
				total += ticket.price
			end
		end
		
		total
	end

	def requires_disclaimer
		user_order_tickets.each do |ticket|
			if ticket.requires_extended_details?
				return true
			end
		end

		return false
	end
	
	def surcharge
		charge = 0.0
		
		if payment_type.surcharge_percent !=nil
			charge = subtotal * (payment_type.surcharge_percent / 100.0)
			if payment_type.surcharge_value != nil
				charge += payment_type.surcharge_value
			end
			charge = charge * (1 + payment_type.surcharge_percent / 100.0)
		elsif payment_type.surcharge_value != nil
			charge = surcharge_value
		end
			
		charge
	end
	
	def total
		subtotal + surcharge
	end
	
	def voidable?
		payment == nil && voided_by_id == nil
	end

	def isvoid?
		voided_by_id != nil
	end
	def ispaid?
		self.payment != nil
	end
	
	def self.paidarel
		uoarel = UserOrder.arel_table
		uoarel[:payment_id].eq(nil).not()
	end

	def self.unpaidarel
		uoarel = UserOrder.arel_table
		uoarel[:payment_id].eq(nil)
	end
end
