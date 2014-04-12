class ApplicationController < ActionController::Base
	include Pundit
  protect_from_forgery
  layout "2015"
  before_filter :title
  helper_method :user_can?, :user_can_visit?

	def title
		@title = "Swancon 40"
	end

	private

	def prepare_backlink
		session[:back] = {controller: controller_name, action: action_name}
		session[:back].merge!(params)
	end

	def stored_location_for(resource_or_scope)
		nil
	end

	def after_sign_in_path_for(resource_or_scope)
		if RoutePolicy.new(current_user).visit?(:seller, :index)
			{action: :sales, controller: "/seller"}
		else
			root_path
		end
	end

	def authorize_path!
		render "layouts/unauthorized", status: :unauthorized unless RoutePolicy.new(current_user).visit?(controller_name, action_name)
	end

	def user_can_visit?(controller, action)
		RoutePolicy.new(current_user).visit?(controller.to_sym, action.to_sym)
	end

  def user_can?(action, object)
    object_is_instance = object.class != Class
    if object_is_instance
      klass = object.class
    else
      klass = object
    end

    policy_instance = nil

    unless action.ends_with?("?")
      action += "?"
    end

    begin
      policy_class = Module.const_get("#{klass.to_s}Policy")
      if object_is_instance
        policy_instance = policy_class.new(current_user, object)
      else
        policy_instance = policy_class.new(current_user)
      end
    rescue NameError => e
      logger.warn "Could not find policy for class #{klass.to_s}"
      return false
    end

    unless action.ends_with?("?")
      action += "?"
    end

    if policy_instance.respond_to? action
      policy_instance.send(action)
    else
      logger.warn "#{klass.to_s}Policy doesn't respond to #{action}"
      false
    end
  end
end
