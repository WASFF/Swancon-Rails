class BaseMailer < ActionMailer::Base
	helper_method :user_can_visit?, :user_can?
	helper :application
	
	def user_can_visit?(*args)
		false
	end

	def user_can?(*args)
		false
	end
end
