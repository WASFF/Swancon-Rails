class ApplicationController < ActionController::Base
	include Pundit
  protect_from_forgery
  layout "2014"
  before_filter :title
#	before_filter :prepare_for_mobile

	def title
		@title = "Swancon 39 - Conjuration"
	end

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

	def stored_location_for(resource_or_scope)
		nil
	end

	def after_sign_in_path_for(resource_or_scope)
#		if permitted_to? :index, :seller
#			{action: :sales, controller: "/seller"}
#		else
			root_path
#		end
	end

	def authorize_path!
		render "layouts/unauthorized", status: :unauthorized unless RoutePolicy.new(current_user).visit?(controller_name, action_name)
	end
end
