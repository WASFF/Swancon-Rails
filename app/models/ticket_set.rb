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

	def sold_tickets
		UserOrderTicket.joins{user_order}.joins{ticket_type.ticket_set}.where{(user_order.voided_by_id == nil) & (ticket_sets.id == my{id})}
	end

	def tickets_for(user)
		UserOrderTicket.joins{user_order}.joins{ticket_type.ticket_set}.where{(user_order.voided_by_id == nil) & (ticket_sets.id == my{id}) & (user_id == user)}
	end

	def pending
		joins = UserOrderTicket.joins{user_order_ticket_transfers}.joins{user_order}.joins{ticket_type.ticket_set}
		joins.where{(user_order_ticket_transfers.confirmed_on == nil) & (ticket_sets.id == my{id})}
	end

	def user_owns_multiple
		userticket = User.joins{user_order_tickets.user_order}.joins{user_order_tickets.ticket_type.ticket_set}.where{(ticket_sets.id == my{id}) & (user_orders.voided_by_id == nil)}.group{users.id}.having{ count(users.id) > 1 }.select{id}
		joins = UserOrderTicket.joins{user_order}.joins{ticket_type.ticket_set}.joins{user}
		joins.where{(user_order.voided_by_id == nil) & (ticket_sets.id == my{id}) & (user.id.in(userticket))}
	end

	def cards_unsent
		UserOrderTicket
			.joins{user_order}
			.joins{ticket_type.ticket_set}
			.where{
				(user_order.voided_by_id == nil) & 
				(ticket_sets.id == my{id}) & 
				(user_order_tickets.card_issued == nil)
			}
	end

	def self.available(user = nil)
		if (user == nil) || (!user.full_store_visible?)
			joins(:ticket_types).where(TicketType.availablearel).group(:id)
		else
			where("1 = 1")
		end
	end

end
