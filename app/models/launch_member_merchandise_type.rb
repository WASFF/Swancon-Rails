class LaunchMemberMerchandiseType < ActiveRecord::Base
	belongs_to :launch_member
	belongs_to :merchandise_type
	belongs_to :payment, :dependent => :destroy

	def options
		options = Array.new
		option_ids = merchandise_options_hash.split(", ")
		option_ids.each do |id|
			options << MerchandiseOption.find(id)
		end
		
		options
	end
end
