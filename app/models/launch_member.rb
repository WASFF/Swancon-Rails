class LaunchMember < ActiveRecord::Base
	has_many :launch_member_ticket_types, :dependent => :destroy
	has_many :launch_member_merchandise_types, :dependent => :destroy
	
	validates :name_first, :presence => true, :length => {:minimum => 1}
	validates :address_street1, :presence => true, :length => {:minimum => 1}
	validates :address_street3, :presence => true, :length => {:minimum => 1}	
	validates :address_postcode, :presence => true, :length => {:minimum => 4}
	validates :address_state, :presence => true, :length => {:minimum => 2}	
	validates :address_country, :presence => true, :length => {:minimum => 2}
	
	before_save :blank_to_null
	
	def blank_to_null
		nullarray = [:name_first, :name_last, :name_badge, :address_street1, :address_street2, :address_street3,
			:address_postcode, :address_state, :address_country, :phoneno, :email]
			
		nullarray.each do |attr|
			if self[attr].strip != nil
				self[attr] = self[attr].strip
				if self[attr] == ""
					self[attr] = nil
				end
			end
		end
	end

	def payments
		ids = launch_member_ticket_types.collect {|item| item.payment_id}
		ids.concat(launch_member_merchandise_types.collect {|item| item.payment_id})
		ids.uniq!
		
		paymentarel = Payment.arel_table
		Payment.where(paymentarel[:id].in(ids))
	end
		
	def name
		if name_badge == nil
			"#{name_first} #{name_last}"
		else
			name_badge
		end
	end
	
	def purchasable_tickets
		if (launch_member_ticket_types.count > 0)
			ticket_type_ids = launch_member_ticket_types.collect {|item| item.ticket_type_id}
			ttarel = TicketType.arel_table
			TicketType.where(ttarel[:id].in(ticket_type_ids).not())
		else
			TicketType
		end
	end
	
end
