class RoutePolicy
  attr_reader :user, :path

  ROLE_PATHS = {
    admin: {
      index: true,
      tickets: true,
      ticket_sets: true,
      ticket_types: true,
      payment_types: true,
      merchandise_sets: true,
      merchandise_options: true,
      merchandise_option_sets: true,
      merchandise_types: true,
      payments: true,
      panel_suggestions: true,
      promoted_items: true,
      member_details: true,
      user_orders: true,
      users: true,
      seller: true,
      vendors: true,
      vendor_orders: true
    },
    committee: {
      index: [:index, :admin],
      tickets: [:index, :export_badges, :export_salesdata, :card_issue, :card_unissue ],
      ticket_sets: [:index, :show, :new, :create, :edit, :update, :show],
      ticket_types: [:index, :show, :new, :create, :edit, :update, :show],
      payment_types: [:index, :show, :new, :create, :edit, :update, :show],
      merchandise_sets: [:index, :show, :new, :create, :edit, :update, :show],
      merchandise_options: [:index, :show, :new, :create, :edit, :update, :show],
      merchandise_option_sets: [:index, :show, :new, :create, :edit, :update, :show],
      merchandise_types: [:index, :show, :new, :create, :edit, :update, :show, :add_image, :remove_image, :update_image_description],
      payments: [:index, :show],
      panel_suggestions: [:destroy, :make_visible, :make_invisible],
      promoted_items: [:index, :form_save],
      member_details: [:new, :edit, :index, :show, :destroy],
      user_orders: :remail,
      users: [:index, :show, :purchase_for, :edit_member_details],
      seller: true
    },
    ticket_seller: {
      index: :adminapp,
      user_orders: :show,
      payments: :show,
      seller: true,
      member_details: [:new, :create]
    },
    user: {
      tickets: [:transfer, :find_user, :confirm_transfer, :reconfirm_transfer, :my ],
      user_orders: [:index, :show, :void, :unvoid ],
      panel_suggestions: [:update, :edit],
      member_details: [:edit_my, :update, :create]
    },
    guest: {
      index: [:index, :start_tracking],
      panel_suggestions: [:index, :show, :new, :create],
      award_nomination: [:index, :show, :new, :create, :edit, :update, :show]
    }
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
    if allowed_paths[controller].is_a? TrueClass
      true
    elsif allowed_paths[controller].is_a? Symbol
      allowed_paths[controller] == action
    elsif allowed_paths[controller].is_a? Array
      allowed_paths[controller].include?(action)
    else
      false
    end
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

