class AwardNomination < ActiveRecord::Base
	belongs_to :award
	belongs_to :user
	has_many :award_nomination_categories, dependent: :destroy
	accepts_nested_attributes_for :award_nomination_categories, :reject_if => lambda { |a| a[:nominee].blank? or a[:work].blank? }, :allow_destroy => true

	def categories
		award_nomination_categories
	end

	def display_name
		if user != nil
			user.display_name
		else
			name
		end
	end

	def submit_button_name
		if self.new_record?
			"Nominate"
		else
			"Modify Nomination"
		end
	end	
end
