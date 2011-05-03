class UsersController < ApplicationController
	filter_resource_access

	def index
		if params[:norole] == "true"
			@rolename = "No Roles"
			roleids = UserRole.group("user_id").all.collect {|item| item.user_id}
			@users = User.where(["id NOT IN (?)", roleids])
		elsif params.key?(:roles)
			@rolename = ""
			rolenames = params[:roles].split(",")
			@users = User.joins(:user_roles)
			rolenames.each do |rolename|
				role = Role.where(:name => rolename.downcase).first
				@users = @users.where("user_roles.role_id" => role.id)
				@rolename = "#{@rolename}#{rolename}, "
			end
			@rolename = @rolename[0..-2]		
			@users = @users.includes(:roles).all
		end

	  respond_to do |format|
	    format.html # index.html.erb
	    format.xml  { render :xml => @users }
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
#		@member_detail = MemberDetail.new
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
	  @user = User.new(params[:user])
		user.skip_confirmation!
		user.confirm!
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

	def update
		if current_user.role_symbols.index(:admin) == nil
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
	    if @user.update_attributes(params[:user])
	      format.html { redirect_to(users_admin_path(@user), :notice => 'User was successfully updated.') }
	      format.xml  { head :ok }
	    else
	      format.html { render :action => "edit" }
	      format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
	    end
	  end
	end

	def destroy
	  @user = User.find(params[:id])
	  @user.destroy

	  respond_to do |format|
	    format.html { redirect_to(users_admin_index_url) }
	    format.xml  { head :ok }
	  end
	end
end