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
			format.json {
				if @user != nil

				else
					array = []
					@users.each do |user| 
						details = {}
						if user.member_detail != nil
							details = {
								"member_detail_attributes[name_first]" =>
									user.member_detail.name_first,
								"member_detail_attributes[name_last]" =>
									user.member_detail.name_last,
								"member_detail_attributes[name_badge]" =>
									user.member_detail.name_badge,
								"member_detail_attributes[address_1]" =>
									user.member_detail.address_1,
								"member_detail_attributes[address_2]" =>
									user.member_detail.address_2,
								"member_detail_attributes[address_3]" =>
									user.member_detail.address_3,								
								"member_detail_attributes[address_postcode]" =>
									user.member_detail.address_postcode,
								"member_detail_attributes[address_state]" =>
									user.member_detail.address_state,
								"member_detail_attributes[address_country]" =>
									user.member_detail.address_country,
								"member_detail_attributes[phone]" =>
									user.member_detail.phone,
								"member_detail_attributes[email_optin]" =>
									user.member_detail.email_optin,
								"member_detail_attributes[disclaimer_signed]" =>
									user.member_detail.disclaimer_signed
							}
						end
						entry = {
							id: user.id,
							username: user.username,
							email: user.email
						}
						array << entry.merge(details)
					end
					render json: array
				end
			}
		end
	end

	def create
		if params[:user] != nil
			if params[:user][:id].to_i == 0
				@user = User.new(params[:user])
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
						@user.member_detail = MemberDetail.new(params[:user][:member_detail_attributes])
						@user.member_detail.save
					else
						@user.member_detail.update_attributes(params[:user][:member_detail_attributes])
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
end
