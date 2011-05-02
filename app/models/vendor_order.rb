class VendorOrder < ActiveRecord::Base
	has_many :user_order_merchandises, :dependent => :nullify

	def merchandise
		user_order_merchandises
	end
end
