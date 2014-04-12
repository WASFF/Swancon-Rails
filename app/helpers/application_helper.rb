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
    if @items.blank?
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

      if user_signed_in? && current_user.admin_panel_visible?
        @items << {name: "Admin", path: admin_path}
      end
    end
    @items[0][:first] = true if @items.length > 0
    @items
  end

  def items_for_tag(name)
    items = []
    tag = ContentTag.find_by_name(name)
    if tag.blank?
      return items
    end
    
    tag.blocks.each do |block|
      item = {title: block.title, text: block.summary}
      item[:path] = {controller:"content_viewer", action:"content", id: block.id}
      ## TODO: put block image here
      item[:image] = "ruby150.png"

      items << item
    end

    items
  end
end
