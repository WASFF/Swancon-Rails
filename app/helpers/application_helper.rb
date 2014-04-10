require 'pp'

module ApplicationHelper
  def render_time(time)
    if time != nil
      time.strftime("%d/%m/%Y %H:%M %Z") 
    else
      "Null"
    end
  end

  def render_money(value)
    number_to_currency(value)
  end

  def promoted_items
    if @promoted_items == nil
      @promoted_items = []
#     promoted_tag_id = Settings.promoted_items_tag_id
#     if promoted_tag_id != nil
        tag = ContentTag.where(id: 6).first
        if tag != nil
          @promoted_items = tag.blocks
        end
#     end
    end
    @promoted_items
  end

  def menu_items
    if @items == nil
      @items = []
      ContentPage.topbar.all.each do |page|
        if page.name != 'home'
          item = {path: {controller:"/content_viewer", action:"page", id: page.name}}
          item[:name] = ""
          page.name.split(" ").each do |word|
            item[:name] += word.capitalize + " "
          end
          item[:name] = item[:name][0..-2]
          @items << item
        end
      end
      @user_items = []
      if user_signed_in?
        @user_items << {name: "My Profile", path: edit_user_registration_path}
        @user_items << {name: "My Tickets", path: tickets_my_path}
        @user_items << {name: "Membership Details", path: edit_my_member_details_path}
        @user_items << {name: "Orders", path: orders_path}
        @user_items << {name: "Log Out", path: destroy_user_session_path}
      else
        @user_items << {name: "Log In", path: new_user_session_path}
        @user_items << {name: "Register", path: new_user_registration_path}
      end
      
      @items = @user_items + @items

      if user_signed_in? && current_user.admin_panel_visible?
        @items << {name: "Admin", path: admin_path}
      end

    end
    @items
  end

  def menu_left
    if @left == nil
      @left = []
      size = menu_items.length / 2
      @left = menu_items[0..size]
    end
    @left
  end

  def menu_right
    if @right == nil
      @right = menu_items[menu_left.length..-1]
    end

    @right
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
