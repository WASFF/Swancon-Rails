class TicketType < ActiveRecord::Base
	belongs_to :ticket_set
	has_many :launch_member_ticket_types
	has_many :user_order_tickets

	scope :available, lambda {
		where(self.availablearel)
	}

	def orders
		user_order_tickets
	end

	def set
		ticket_set
	end
	
	def set=(value)
		self.ticket_set = value
	end

	def available?
		if (available_from == nil) and (available_to == nil)
			true
		elsif (available_from == nil)
			 Time.now <= available_to
		elsif (available_to == nil)
				available_from <= Time.now 
		else
			(available_from <= Time.now) and (Time.now <= available_to)
		end
	end
	
	def order_name
		"#{set.name} Ticket #{name}"
	end
	
	def deletable?
		user_order_tickets.count == 0
	end	
	
	def self.availablearel
		ticketarel = TicketType.arel_table
		arelquery = Arel::Nodes::Grouping.new(ticketarel[:available_from].eq(nil).and(ticketarel[:available_to].eq(nil)))
		arelquery = arelquery.or(Arel::Nodes::Grouping.new(ticketarel[:available_from].eq(nil).and(ticketarel[:available_to].gteq(Time.now))))
		arelquery = arelquery.or(Arel::Nodes::Grouping.new(ticketarel[:available_from].lteq(Time.now).and(ticketarel[:available_to].eq(nil))))
		arelquery = arelquery.or(Arel::Nodes::Grouping.new(ticketarel[:available_from].lteq(Time.now).and(ticketarel[:available_to].gteq(Time.now))))
		arelquery
	end
end
