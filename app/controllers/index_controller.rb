class IndexController < ApplicationController
	before_filter :authorize_path!

	def index
		@page = ContentPage.where(:home => true).first
	end	

	def set_con_mode
		SiteSettings.con_mode = params[:enable] == "true"
		redirect_to admin_path
	end

end
