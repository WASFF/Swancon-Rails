class UserOrderMerchandise < ActiveRecord::Base
	belongs_to :merchandise_type
	belongs_to :user_order
#	belongs_to :user, :through => :user_order
	has_many :user_order_merchandise_options, :dependent => :destroy	
	belongs_to :vendor_order
	
	scope :unpaid, lambda {
		joins(:user_order).where(UserOrder.unpaidarel)
	}
	
	scope :outstanding, lambda {
		joins(:user_order).where(UserOrder.paidarel).where(:vendor_order_id => nil).where(:shipped_at => nil)
	}
	
	scope :placed, lambda {
		joins(:user_order).where(UserOrder.paidarel).where("vendor_order_id IS NOT NULL").where(:arrived_at => nil).where(:shipped_at => nil)
	}
	
	scope :arrived, lambda {
		joins(:user_order).where(UserOrder.paidarel).where("vendor_order_id IS NOT NULL").where("arrived_at IS NOT NULL").where(:shipped_at => nil)
	}	
	
	scope :completed, lambda {
		joins(:user_order).where(UserOrder.paidarel).where("shipped_at IS NOT NULL")
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
