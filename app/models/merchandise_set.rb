class MerchandiseSet < ActiveRecord::Base
	has_many :merchandise_types
	
	def merchandise
		merchandise_types
	end
end
