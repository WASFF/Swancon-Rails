class PaymentType < ActiveRecord::Base

	before_save :blank_to_null
	
	def blank_to_null
		nullfloat = [:surcharge_value, :surcharge_percent]
			
		nullfloat.each do |attr|
			if self[attr] != nil
				if self[attr] == 0
					self[attr] = nil
				end
			end
		end
	end

	def form_display
		value = "#{name}"

		if surcharge_percent != nil
			value += " + #{surcharge_percent}%"
		end

		
		if surcharge_value != nil
			value += " + $#{surcharge_value}"
		end

		value
	end

	def self.onlineTypes
		return PaymentType.where(available_online: true)
	end

	def self.resellerTypes
		return PaymentType.where(available_to_ticket_seller: true)
	end

end
