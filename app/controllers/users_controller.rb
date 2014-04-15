class UsersController < ApplicationController
	before_filter :authorize_path!

	def index
		@users = User.joins("LEFT OUTER JOIN member_details ON users.id = member_details.user_id").includes(:member_detail)
		@search = false
		if params[:role] != nil
			if params[:role][:no_role] != nil
				roleids = UserRole.group("user_id").all.collect {|item| item.user_id}
				@users = @users.where(["users.id NOT IN (?)", roleids])
				@search = true
			else
				@users = @users.joins(:user_roles)
				params[:role].keys.each do |key|
					role = Role.where(:name => key.downcase).first
					if (role != nil)
						@users = @users.where("user_roles.role_id" => role.id)
						@search = true
					end
				end
			end
		end

		if params[:disclaimer] != nil and params[:disclaimer] != "null"
			@search = true
			if params[:disclaimer] == "true"
				@users = @users.where("member_details.disclaimer_signed = 't'")
			else
				@users = @users.where("member_details.disclaimer_signed = 'f'")
			end
		end

		if params[:name_search] != nil
			if params[:name_search].strip.length > 0
				searchstring = "%#{params[:name_search].strip}%"
				@search = true
				@users = @users.where("member_details.name_first LIKE ? OR member_details.name_last LIKE ? OR member_details.name_badge LIKE ? or users.username LIKE ?", searchstring, searchstring, searchstring, searchstring)
			end
		end

		respond_to do |format|
			format.html # index.html.erb
			format.js
		end
	end

	def show
		if current_user.role_symbols.index(:admin) != nil
			@user = User.find(params[:id])
		else
			@user = current_user
		end
	
		respond_to do |format|
	    format.html # show.html.erb
	    format.xml  { render :xml => @user }
	  end
	end

	def new
	  @user = User.new
	  respond_to do |format|
	    format.html # new.html.erb
	    format.xml  { render :xml => @user }
	  end
	end

	def edit
		if current_user.role_symbols.index(:admin) != nil
			@user = User.find(params[:id])
		else
			@user = current_user
		end
	end

	def create
		@user = User.new(user_params)
		if @user.password.strip == ""
			@user.password = Devise.friendly_token[0,20]
			@user.password_confirmation = @user.password
		end

		if params[:user][:member_detail_attributes] != nil
			print "Username is: '#{@user.username.strip}'\n"
			if @user.username.strip == ""
				print "USERNAME IS BLANK!\n"
				if @user.details.name_badge.strip != ""
					@user.username = @user.details.name_badge
				else
					@user.username = "#{@user.details.name_first}-#{@user.details.name_last}"
				end
			end
		end

		@user.skip_confirmation!
		@user.confirm!
				
		respond_to do |format|
			if @user.save
				format.html { redirect_to(users_admin_path(@user), :notice => 'User was successfully created.') }
				format.xml  { render :xml => @user, :status => :created, :location => @user }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	def edit_member_details
		@user = User.find(params[:id])

		if @user.member_detail = nil
			@member_detail = @user.member_detail
			render "member_details/edit"
		else
			@member_detail = MemberDetail.new
			@member_detail.user = @user
			@member_detail.name_badge = @member_detail.user.username
			render "member_details/new"
		end
	end

	def update
		unless current_user.role_symbols.include? :admin
			params[:user].delete(:role_ids)
		else
			if !params[:user].key?(:role_ids)
				params[:user][:role_ids] = []
			end			
		end
		
		if params[:user][:password].strip == ""
			params[:user].delete(:password)
			params[:user].delete(:password_confirmation)
		end
	  
		@user = User.find(params[:id])

	  respond_to do |format|
	    if @user.update_attributes(user_params)
	      format.html { redirect_to(users_admin_path(@user), :notice => 'User was successfully updated.') }
	      format.xml  { head :ok }
	    else
	      format.html { render :action => "edit" }
	      format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
	    end
	  end
	end
	
	def purchase_for
		@user = User.find(params[:id])
		session[:store_user_id] = @user.id
		redirect_to :controller => :store, :action => :index
	end

	def destroy
	  @user = User.find(params[:id])
	  @user.destroy

	  respond_to do |format|
	    format.html { redirect_to(users_admin_index_url) }
	    format.xml  { head :ok }
	  end
	end

private
	def user_params
		params.require(:user).permit [
				:username, :email, :password, :password_confirmation, role_ids: []
			]
	end
end
