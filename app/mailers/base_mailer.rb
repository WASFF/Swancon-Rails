class BaseMailer < ActionMailer::Base
	helper_method :user_can_visit?, :user_can?
	helper :application

	def mail(headers = {}, &block)
		if Rails.env == "staging"
			if headers.has_key? :current_user and headers[:current_user].present?
				headers["X-original-to"] = headers[:to]
				headers[:to] = headers[:current_user].email
				if headers[:cc].present?
					headers["X-original-cc"] = headers[:cc]
					headers[:cc] = nil
				end
				if headers[:bcc].present?
					headers["X-original-bcc"] = headers[:bcc]
					headers[:bcc] = nil
				end
				super(headers)
			end
		else
			super(headers)
		end
	end	
	
	def user_can_visit?(*args)
		false
	end

	def user_can?(*args)
		false
	end
end
