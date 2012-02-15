class AwardNominationCategory < ActiveRecord::Base
	belongs_to :award_nomination
	belongs_to :award_category

	def parent
		award_nomination
	end

	def parent=(value)
		self.award_nomination = value
	end	

	def category
		award_category
	end

	def category=(value)
		self.award_category = value
	end

end
