class IndexController < ApplicationController
	filter_access_to :all

	def index
		@page = ContentPage.where(:home => true).first
	end	
end
