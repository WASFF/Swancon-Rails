class SellerController < ApplicationController
	filter_access_to :all

	def select
		@users = User.joins("LEFT OUTER JOIN member_details ON users.id = member_details.user_id").includes(:member_detail)
		if params[:name_search] != nil
			search = params[:name_search].gsub(/[^([a-z]|[A-Z]|[0-9])]/, "").strip
			if search.length > 2
				searchstring = "%#{search}%"
				emailsearch = "#{search}%"
				@search = true
				wherestring = "member_details.name_first LIKE ? OR member_details.name_last LIKE ? OR member_details.name_badge LIKE ? or users.username LIKE ? or users.email LIKE ?"
				@users = @users.where(wherestring, searchstring, searchstring, searchstring, searchstring, emailsearch)
			end
		elsif params[:id] != nil
			@user = User.where(id: params[:id].to_i).first
			session[:store_user_id] = @user.id
			redirect_to controller: :store
			return
		end

		respond_to do |format|
			format.html # index.html.erb
			format.js
		end
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
				redirect_to controller: :store
				return
			else
				@saved = false
			end				
		else
			@user = User.new()
			@user.build_member_detail
			@saved = false
		end
	end

	def clear
		session[:store_user_id] = nil
		session[:cart] = nil
		render "select"
	end

	def sales
		@orders = UserOrder.where(operator_id: current_user.id)
		@search = false

		if params[:paid] != nil
			@search = true
			if params[:paid] == "no"
				@orders = @orders.where(payment_id: nil)
			elsif params[:paid] == "yes"
				@orders = @orders.where(UserOrder.arel_table[:payment_id].not_eq(nil))
			end
		end

		respond_to do |format|
			format.html # index.html.erb
			format.js
		end
	end
end
