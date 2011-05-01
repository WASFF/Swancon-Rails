class TicketSet < ActiveRecord::Base
	has_many :ticket_types

	def tickets
		ticket_types		
	end
end
