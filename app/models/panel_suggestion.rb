class PanelSuggestion < ActiveRecord::Base
	belongs_to :user
	validates :user_name, :presence => true, :allow_blank => false, :unless => :associated_with_user?
	validates :user_email, :presence => true, :allow_blank => false, :unless => :associated_with_user?

	def allowed_to_edit?(user)
		if user == nil
			false
		elsif user.role_symbols.include?(:committee)
			true
		elsif user == self.user
			true
		else
			false
		end
	end

	def display_name
		if user != nil
			return user.display_name
		else
			return user_name
		end
	end

	def submit_button_name
		if self.new_record?
			"Submit Suggestion"
		else
			"Edit Suggestion"
		end
	end

	def associated_with_user?
		user != nil
	end

	def self.allowed_to_administer?(user)
		if user.role_symbols.include?(:committee)
			true
		else
			false
		end
	end
end
