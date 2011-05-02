class UserOrderMerchandise < ActiveRecord::Base
	belongs_to :merchandise_type
	belongs_to :user_order
	has_many :user_order_merchandise_options, :dependent => :destroy	
	
	scope :unpaid, lambda {
		joins(:user_order).where(UserOrder.unpaidarel)
	}
	
	scope :outstanding, lambda {
		joins(:user_order).where(UserOrder.paidarel).where(:vendor_order_id => nil)
	}
	
	scope :optionsort, lambda {
	}
		
	def price
		merchandise_type.price
	end
	
	def name
		merchandise_type.name
	end
	
	def options
		user_order_merchandise_options
	end
end
