class User < ActiveRecord::Base
	has_many :user_roles, :dependent => :destroy
	has_many :user_omni_auths, :dependent => :destroy
	has_many :roles, :through => :user_roles	
	
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
	devise	:database_authenticatable, :registerable, :confirmable,
					:recoverable, :rememberable, :trackable, :validatable,
					:omniauthable

  # Setup accessible (or protected) attributes for your model
	attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :role_ids  

	after_create :add_user_role

	def displayRoles
		output = ""
		roles.each do |role|
			output += role.name + ", "
		end
		
		output[0..-3]
	end

	def role_symbols
		roles.map do |role|
			role.name.underscore.to_sym
		end
	end
	
	def add_user_role
		self.roles << Role.where(:name => "user").first
	end

	# Class Functions
  def self.find_by_username_or_email(username, email)
		userarel = User.arel_table
		arelquery = userarel[:username].eq(username)
		arelquery = arelquery.or(userarel[:email].eq(email))
		User.where(arelquery).first
  end	
	
	def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
		data = access_token['extra']['user_hash']
		user = User.find_by_omniauth("facebook",data["id"].to_i)
		if signed_in_resource == nil

			if user == nil
				username = data["username"]
				email = data["email"]
				user = self.find_by_username_or_email(username, email)
				if (user != nil)
					# TODO: Errors - can't create user because a matching user eists
					return nil
				end
				user = User.new(:username => data["username"], :email => data["email"], :password => Devise.friendly_token[0,20])
				user.skip_confirmation!
				user.confirm!
				user.save

				if user.save
					temp = UserOmniAuth.create!(:authtype => "facebook", :idvalue => data["id"].to_i, :user_id => user.id)			
				end
			end
		
			user
		else
			if user == signed_in_resource
				user
			elsif user == nil
				UserOmniAuth.create!(:authtype => "facebook", :idvalue => data["id"].to_i, :user_id => signed_in_resource.id)
				user
			else
				# ERROR - already associated with a different account!?
				logger.error("Facebook ID: #{data["id"].to_i} associated with User ID #{user.id}")
				nil
			end
		end
	end

	def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
		data = access_token['extra']['user_hash']
		user = User.find_by_omniauth("twitter",data["id"])
		if signed_in_resource == nil
			if user == nil
				username = data["screen_name"]
				email = "#{data["screen_name"]}@twitter.com"
				user = self.find_by_username_or_email(username, email)
				if user != nil
					# TODO: Errors - can't create user because a matching user exists.
					return nil
				end
				user = User.new
				user.username = username
				user.email = email
				user.password = Devise.friendly_token[0,20]
				user.password_confirmation = user.password
				user.skip_confirmation!
				user.confirm!
				if user.save
					temp = UserOmniAuth.create!(:authtype => "twitter", :idvalue => data["id"].to_i, :user_id => user.id)
				end
			end
		
			user
		else
			if user == signed_in_resource
				user
			elsif user == nil
				UserOmniAuth.create!(:authtype => "twitter", :idvalue => data["id"].to_i, :user_id => signed_in_resource.id)
				user
			else
				# ERROR - already associated with a different account!?
				logger.error("Facebook ID: #{data["id"].to_i} associated with User ID #{user.id}")
				nil
			end
		end
	end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.username = data["username"]
      elsif data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["user_hash"]
				user.email = data["email"]
			end
    end
  end

	def self.find_by_omniauth(type, id)
		omniauth = UserOmniAuth.where(:authtype => type, :idvalue => id.to_i).first
		if omniauth == nil
			return nil
		end
		omniauth.user		
	end

end
