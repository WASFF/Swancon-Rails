class RoutePolicy 
  attr_reader :user, :path

  ROLE_PATHS = {
    admin: {
      index: true,
      tickets: true,
      user_orders: true,
      seller: true
    },
    committee: {
      index: true,
      tickets: [:index, :export_badges, :export_salesdata, :card_issue, :card_unissue ],
      user_orders: :remail,
      seller: true
    },
    ticket_seller: {
      user_orders: :show,
      seller: true,
      member_details: [:new, :create]
    },
    user: {
      tickets: [:transfer, :find_user, :confirm_transfer, :reconfirm_transfer, :my ],
      user_orders: [:index, :show, :void, :unvoid ]
    },
    guest: {index: [:index]}
  }.freeze

  def initialize(user)
    @user = user
  end

  def visit?(controller, action)
    allowed_paths = {}
    merged_user = false
    unless @user.blank?
      @user.role_symbols.each do |role|
        allowed_paths = merge_paths(allowed_paths, ROLE_PATHS[role]) if ROLE_PATHS.has_key? role
        if role == :user
          merged_user = true
        end
      end
      allowed_paths = merge_paths(allowed_paths, ROLE_PATHS[:user]) unless merged_user
    end
    allowed_paths = merge_paths(allowed_paths, ROLE_PATHS[:guest])
    controller = controller.to_sym
    action = action.to_sym
    unless allowed_paths.has_key? controller
      return false
    end
    allowed_paths[controller] == true or allowed_paths[controller].include?(action)
  end

private
  def merge_paths(original, to_merge)
    merged = original
    to_merge.each do |key, val|
      unless merged.has_key? key
        merged[key] = val
      else 
        merged_val_class = merged[key].class
        if merged_val_class != TrueClass
          merged_val = merged[key] 
          merged_val = [merged[key]] unless merged_val_class == Array
          val_class = val.class
          if val_class == TrueClass
            merged_val = true
          elsif val_class == Array
            merged_val += val
          else
            merged_val += [val]
          end
          merged[key] = merged_val
        end
      end
    end

    merged
  end
end

