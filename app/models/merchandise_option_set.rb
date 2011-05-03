class MerchandiseOptionSet < ActiveRecord::Base
	has_many :merchandise_options

	def deletable?
		merchandise_options.count == 0
	end
end
