class UserOrderMerchandise < ActiveRecord::Base
	belongs_to :merchandise_type
	belongs_to :user_order
	has_many :user_order_merchandise_options, :dependent => :destroy
	
	def price
		merchandise_type.price
	end
	
	def options
		user_order_merchandise_options
	end
end
