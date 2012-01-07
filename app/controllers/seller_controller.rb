class SellerController < ApplicationController
	filter_access_to :all

	def select
	end

	def create
		if params[:user] != nil
			@user = User.new(params[:user])
			if @user.password.strip == ""
				@user.password = Devise.friendly_token[0,20]
				@user.password_confirmation = @user.password
			end

			if @user.username.strip == ""
				if @user.details.name_badge.strip != ""
					@user.username = @user.details.name_badge
				else
					@user.username = "#{@user.details.name_first}-#{@user.details.name_last}"
				end
			end

			if @user.email == ""
				
			end

			@user.skip_confirmation!
			@user.confirm!
			
			if @user.save
				@saved = true
				session[:store_user_id] = @user.id
			else
				@saved = false
			end				
		else
			@user = User.new()
			@user.build_member_detail
			@saved = false
		end
	end
end
