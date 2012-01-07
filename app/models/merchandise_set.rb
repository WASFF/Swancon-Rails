class MerchandiseSet < ActiveRecord::Base
	has_many :merchandise_types

	def merchandise
		merchandise_types
	end

	def deletable?
		merchandise_types.count == 0
	end

	def self.available(user = nil)
		if (user == nil) || (!user.full_store_visible?)
			joins(:merchandise_types).where(MerchandiseType.availablearel).group(:id)
		else
			where("1 = 1")
		end
	end

end
