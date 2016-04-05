class MemberDetail < ActiveRecord::Base
	belongs_to :user

	validates :name_first, :presence => true, :length => {:minimum => 1}
	validates :address_1, :presence => true, :length => {:minimum => 1}
	validates :address_3, :presence => true, :length => {:minimum => 1}
	validates :address_postcode, :presence => true, :length => {:minimum => 4}
	validates :address_state, :presence => true, :length => {:minimum => 2}
	validates :address_country, :presence => true, :length => {:minimum => 2}
    validates :disclaimer_signed, :inclusion => {:in => [true,1] }

	before_save :blank_to_null

	def blank_to_null
		nullarray = [:name_first, :name_last, :name_badge, :address_1, :address_2, :address_3,
			:address_postcode, :address_state, :address_country, :phoneno]

		nullarray.each do |attr|
			if self[attr] != nil
				self[attr] = self[attr].strip
				if self[attr] == ""
					self[attr] = nil
				end
			end
		end
	end

	def name_real
		"#{name_first} #{name_last}"
	end

	def email
		user.email
	end

	def name
		if name_badge != nil
			name_badge
		else
			name_real
		end
	end

	def self.email_list
		MemberDetail.includes(:user).where(email_optin: true).where.not(users: {email: ''}).where.not(users: {email: nil})
	end
end
