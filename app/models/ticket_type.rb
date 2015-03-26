class TicketType < ActiveRecord::Base
	belongs_to :ticket_set
	has_many :launch_member_ticket_types
	has_many :user_order_tickets

	def orders
		user_order_tickets
	end

	def set
		ticket_set
	end
	
	def set=(value)
		self.ticket_set = value
	end

	def requires_extended_details?
		ticket_set.requires_extended_details
	end

	def available?
		available_in_time_range && available_under_maximum
	end
	
	def order_name
		"#{set.name} Ticket #{name}"
	end
	
	def deletable?
		user_order_tickets.count == 0
	end	

	def sold
		user_order_ids = user_order_tickets.pluck(:user_order_id).uniq
		user_order_ids = UserOrder.where(id: user_order_ids).where(voided_by_id: nil).pluck(:id)
		user_order_tickets.where(user_order_id: user_order_ids).count
	end
	
	def self.available(user = nil)
		if (user == nil) || (!user.full_store_visible?)
			where(self.availablearel)
		else
			where("1 = 1")
		end
	end

	def self.availablearel
		ticketarel = TicketType.arel_table
		arelquery = Arel::Nodes::Grouping.new(ticketarel[:available_from].eq(nil).and(ticketarel[:available_to].eq(nil)))
		arelquery = arelquery.or(Arel::Nodes::Grouping.new(ticketarel[:available_from].eq(nil).and(ticketarel[:available_to].gteq(Time.now))))
		arelquery = arelquery.or(Arel::Nodes::Grouping.new(ticketarel[:available_from].lteq(Time.now).and(ticketarel[:available_to].eq(nil))))
		arelquery = arelquery.or(Arel::Nodes::Grouping.new(ticketarel[:available_from].lteq(Time.now).and(ticketarel[:available_to].gteq(Time.now))))
		arelquery
	end

private
	def available_under_maximum
		if (maximum_number.blank?)
			true
		else
			sold < maximum_number
		end
	end

	def available_in_time_range
		if (available_from.blank?) and (available_to.blank?)
			true
		elsif (available_from.blank?)
			 Time.now <= available_to
		elsif (available_to.blank?)
				available_from <= Time.now 
		else
			(available_from <= Time.now) and (Time.now <= available_to)
		end		
	end


end
