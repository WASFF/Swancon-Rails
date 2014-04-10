class IndexController < ApplicationController
	before_filter :authorize_path!

	def index
		@page = ContentPage.where(:home => true).first
	end	

end
