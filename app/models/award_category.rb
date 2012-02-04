class AwardCategory < ActiveRecord::Base
	belongs_to :award
	has_many :award_nomination_categories

	def submit_button_name
		if self.new_record?
			"Add Award Category"
		else
			"Modify Award Category"
		end
	end

	def nominations
		award_nomination_categories
	end

	def destroyable?
		award_nomination_categories.count == 0
	end
end
