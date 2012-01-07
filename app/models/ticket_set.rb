class TicketSet < ActiveRecord::Base
	has_many :ticket_types

	def deletable?
		ticket_types.count == 0
	end

	def tickets
		ticket_types		
	end

	def types
		ticket_types
	end

	def self.available(user = nil)
		if (user == nil) || (!user.full_store_visible?)
			joins(:ticket_types).where(TicketType.availablearel).group(:id)
		else
			where("1 = 1")
		end
	end

end
