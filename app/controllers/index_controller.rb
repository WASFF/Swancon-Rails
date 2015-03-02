class IndexController < ApplicationController
	before_filter :authorize_path!

	def index
		@page = ContentPage.where(:home => true).first
	end	

  def start_tracking
    tag = AdvertisingTag.where(funnel_name: params[:id]).first
    if tag.present?
      cookies[:advertising_tag_id] = {value: tag.id, expires: 1.month.from_now }
      session[:advertising_tag_id] = tag.id
    end
    redirect_to root_path
  end

	def set_con_mode
		SiteSettings.con_mode = params[:enable] == "true"
		redirect_to admin_path
	end

end
