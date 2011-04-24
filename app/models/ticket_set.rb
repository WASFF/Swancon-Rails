class TicketSet < ActiveRecord::Base
	has_many :ticket_types
end
