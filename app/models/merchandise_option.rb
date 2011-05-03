class MerchandiseOption < ActiveRecord::Base
	belongs_to :merchandise_type
	belongs_to :merchandise_option_set
	has_many :user_order_merchandise_options

	def set
		merchandise_option_set
	end

	def displayfull
		if description == nil
			name
		else
			"#{name} - #{description}"
		end
	end

	def deletable?
		user_order_merchandise_options.count == 0
	end
end
