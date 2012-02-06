class CleanInvalidMemberDetails < ActiveRecord::Migration
	def change
		User.all.each do |user|
			if user.member_detail != nil
				first = true
				MemberDetail.where(user_id: user.id).each do |detail|
					if (first)
						first = false
					else
						detail.destroy
					end
				end
			end
		end
	end
end
