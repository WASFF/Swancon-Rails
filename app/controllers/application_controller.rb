class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :prepare_for_mobile

	private
	def mobile_device?
		logger.debug("User Agent: #{request.user_agent}")
		if session[:mobile_param]
			session[:mobile_param] == "1"
		elsif request.user_agent =~ /iPad/
			false
		elsif request.user_agent =~ /GT-P1000T/
			false
		else
			request.user_agent =~ /Mobile|webOS/
		end
	end
	helper_method :mobile_device?

	def prepare_for_mobile
		session[:mobile_param] = params[:mobile] if params[:mobile]
		request.format = :mobile if mobile_device? and request.format != "json"
	end

	def prepare_backlink
		session[:back] = {controller: controller_name, action: action_name}
		session[:back].merge!(params)
	end
end