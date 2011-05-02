module ApplicationHelper
	def render_time(time)
		if time != nil
			time.strftime("%d/%m/%Y %H:%M %Z") 
		else
			"Null"
		end
	end

end
