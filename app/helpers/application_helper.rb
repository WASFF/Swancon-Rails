module ApplicationHelper
	def render_time(time)
		if time != nil
			time.strftime("%d/%m/%Y %H:%M %Z") 
		else
			"Null"
		end
	end

	def render_money(value)
		number_to_currency(value)
	end
end
