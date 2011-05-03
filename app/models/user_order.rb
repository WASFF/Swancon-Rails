class UserOrder < ActiveRecord::Base
	belongs_to :user
	belongs_to :operator, :class_name => "User"
	has_many :user_order_merchandise, :dependent => :destroy
	has_many :user_order_tickets, :dependent => :destroy
	belongs_to :payment
	belongs_to :payment_type

	scope :paid, lambda {
		where(self.paidarel)
	}

	def invoice_number
		sprintf "DOOMCON-ORDER-%05d", id
	end
	
	def invoice
		sprintf "DOOMCON-ORDER-%05d", id		
	end
	
	def short_invoice
		sprintf "DCO-%05d", id		
	end
	
	def short_invoice_number
		sprintf "DCO-%05d", id
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
			total += ticket.price
		end
		
		total
	end
	
	def surcharge
		total = 0.0
		
		if payment_type.surcharge_percent !=nil
			total = subtotal * (payment_type.surcharge_percent / 100.0)
		end
		
		if payment_type.surcharge_value != nil
			total += surcharge_value
		end
	
		total
	end
	
	def total
		subtotal + surcharge
	end
	
	def cancellable
		payment == nil	
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
