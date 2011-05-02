class LaunchMemberTicketType < ActiveRecord::Base
	belongs_to :launch_member
	belongs_to :ticket_type
	belongs_to :payment
end
