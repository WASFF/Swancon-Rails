class PanelSuggestion < ActiveRecord::Base
	belongs_to :user

	def allowed_to_edit?(user)
		if user == nil
			return false
		end
		
		if user.role_symbols.include?(:committee)
			return true
		end
		
		if user == self.user
			return true
		end
		
		return false
	end

	def submit_button_name
		if self.new_record?
			"Submit Suggestion"
		else
			"Edit Suggestion"
		end
	end

end
