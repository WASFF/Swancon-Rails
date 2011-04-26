class TicketType < ActiveRecord::Base
	belongs_to :ticket_set
	has_many :launch_member_ticket_types
end
