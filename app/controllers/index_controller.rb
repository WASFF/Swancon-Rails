class IndexController < ApplicationController
	def index
		@page = ContentPage.where(:home => true).first
	end	
end
