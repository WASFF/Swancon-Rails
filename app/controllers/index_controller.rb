class IndexController < ApplicationController
	filter_access_to :all

	def index
		redirect_to :controller => "content_viewer", :action => "page"
	end	
end
