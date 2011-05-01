class UserOrderMerchandiseOption < ActiveRecord::Base
	belongs_to :user_order_merchandise
	belongs_to :merchandise_option
	
	def set
		merchandise_option.set
	end
	
	def name
		merchandise_option.name
	end
end
