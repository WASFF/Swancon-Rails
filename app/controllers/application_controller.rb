class ApplicationController < ActionController::Base
	include Pundit
  protect_from_forgery
  layout "2016"
  before_filter :title
  helper_method :user_can?, :user_can_visit?
  serialization_scope :view_context

	def title
		@title = "Swancon 41"
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
    route_policy = RoutePolicy.new(current_user)
		if route_policy.visit?(:index, :admin)
			{action: :admin, controller: "/index"}
		elsif route_policy.visit?(:seller, :index)
      {action: :sales, controller: "/seller"}
    else
			{action: :index, controller: "/store"}
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

    unless action.to_s.ends_with?("?")
      action = action.to_s + "?"
    end

    if policy_instance.respond_to? action
      policy_instance.send(action)
    else
      logger.warn "#{klass.to_s}Policy doesn't respond to #{action}"
      false
    end
  end
end
