class RoutePolicy 
  attr_reader :user, :path

  ROLE_PATHS = {
    admin: ["index#admin"],
    committee: ["index#admin"],
    guest: ["index#index"]
  }

  def initialize(user)
    @user = user
  end

  def visit?(controller, action)
    allowed_paths = []
    unless @user.blank?
      @user.role_symbols.each do |role|
        allowed_paths += ROLE_PATHS[role] if ROLE_PATHS.has_key? role
      end
    end
    allowed_paths += ROLE_PATHS[:guest]
    path = "#{controller}##{action}"
    allowed_paths.include? path
  end
end

