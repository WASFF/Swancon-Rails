class TicketSet < ActiveRecord::Base
	has_many :ticket_types

	#TODO: Requires Details. disclaimer signed.

	scope :available, lambda {
		joins(:ticket_types).where(TicketType.availablearel).group(:id)
	}
	
	def deletable?
		ticket_types.count == 0
	end

	def tickets
		ticket_types		
	end
end
