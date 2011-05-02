class MerchandiseSet < ActiveRecord::Base
	has_many :merchandise_types
	
	scope :available, lambda {
		joins(:merchandise_types).where(MerchandiseType.availablearel).group(:id)
	}
	
	def merchandise
		merchandise_types
	end
end
