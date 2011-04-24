class MerchandiseOption < ActiveRecord::Base
	belongs_to :merchandise_type
	belongs_to :merchandise_option_set

	def set
		merchandise_option_set
	end

end
