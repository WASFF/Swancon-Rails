class MerchandiseType < ActiveRecord::Base
		belongs_to :merchandise_set
		has_many :merchandise_options
		
		def option_sets
			MerchandiseOptionSet
		end
		
		def options
			merchandise_options
		end
end
