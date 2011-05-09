class Vendor < ActiveRecord::Base
	has_many :vendor_orders
	
	def orders
		vendor_orders
	end
	
	def deletable?
		vendor_orders.count == 0
	end	
	
	def self.list_for_order_create
		self.all.collect {|item| [item.name, item.id]}
	end
end
