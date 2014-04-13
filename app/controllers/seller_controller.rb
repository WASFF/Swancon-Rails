class SellerController < ApplicationController
	before_filter :authorize_path!

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

		include_tickets = SiteSettings.con_mode

		respond_to do |format|
			format.html # index.html.erb
			format.js
			format.json { render json: @users, root: "users", include_member_details: true, include_ticket_details: include_tickets }
		end
	end

	def create
		if params[:user] != nil
			if params[:user][:id].to_i == 0
				@user = User.new(user_params)
				if @user.password == nil || @user.password.strip == ""
					@user.password = Devise.friendly_token[0,20]
					@user.password_confirmation = @user.password
				end

				if @user.username == nil || @user.username.strip == ""
					if @user.details.name_badge != nil && @user.details.name_badge.strip != ""
						@user.username = @user.details.name_badge
					else
						@user.username = "#{@user.details.name_first}-#{@user.details.name_last}"
					end
				end

				@user.skip_confirmation!
				@user.confirm!

			else
				@user = User.where(id: params[:user][:id].to_i).first
				if @user == nil
					respond_to do |respond| 
						respond.json {
							render json: {
								error: {user_id: "User Not Found" }
							}, status: :error
						}
					end
					return
				else
					if @user.member_detail == nil
						@user.member_detail = MemberDetail.new(user_params[:member_detail_attributes])
						@user.member_detail.save
					else
						@user.member_detail.update_attributes(user_params[:member_detail_attributes])
						@user.save
					end
				end
			end

#			pp @user
#			pp @user.member_detail

			if @user.save
				@saved = true
                @saved_name= @user.order_name
				session[:store_user_id] = @user.id
				#redirect_to controller: :store
			else
				@saved = false
			end				
		else
			@user = User.new()
			@user.build_member_detail
			@saved = false
		end

		respond_to do |respond|
			respond.json {
				if @saved
					render json: {status: "ok"}, status: :ok 
				else
					render json: {
						error: @user.errors
					}, status: :error
				end
			}
			respond.html {

			}
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

private
	def user_params
		params.require(:user).permit :username, :email, :password, :password_confirmation, 
			member_detail_attributes: [
				:name_first, :name_last, :name_badge, :address_1, :address_2, :address_3,
				:address_postcode, :address_country, :address_state, :phone, :email_optin,
				:disclaimer_signed
			]
	end
end
