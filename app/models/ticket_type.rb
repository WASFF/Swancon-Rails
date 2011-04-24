class TicketType < ActiveRecord::Base
	belongs_to :ticket_set
end
