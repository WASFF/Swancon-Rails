class Award < ActiveRecord::Base
	has_many :award_categories, dependent: :destroy
	has_many :award_nominations

	def categories
		award_categories
	end

	def destroyable?
		award_nominations.count == 0
	end

	def nominations
		award_nominations
	end

	def category_nominations
		category_ids = award_categories.all.collect {|item| item.id }
		AwardNominationCategory.where(award_category_id: category_ids)
	end

	def submit_button_name
		if self.new_record?
			"Add Award Type"
		else
			"Modify Award Type"
		end
	end
end
