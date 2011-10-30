class TicketSet < ActiveRecord::Base
	has_many :ticket_types

	scope :available, lambda {
		joins(:ticket_types).where(TicketType.availablearel).group(:id)
	}
	
	def deletable?
		ticket_types.count == 0
	end

	def tickets
		ticket_types		
	end

	def types
		ticket_types
	end
end
