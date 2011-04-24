class MerchandiseSet < ActiveRecord::Base
	has_many :merchandise_types
end
