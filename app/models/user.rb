class User < ActiveRecord::Base
	has_many :user_roles
	has_many :roles, :through => :user_roles	
	
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
	devise	:database_authenticatable, :registerable, :confirmable,
					:recoverable, :rememberable, :trackable, :validatable,
					:omniauthable

  # Setup accessible (or protected) attributes for your model
	attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :role_ids  

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
	
	def after_create
		self.roles << Role.where(:name => "user").first
	end

	# Class Functions
	def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
		data = access_token['extra']['user_hash']
		if user = User.find_by_email(data["email"])
			user
		else # Create an user with a stub password. 
			User.create!(:email => data["email"], :password => Devise.friendly_token[0,20]) 
		end
	end

	def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
		data = access_token['extra']['user_hash']
		if user = User.find_by_email(data["email"])
			user
		else # Create an user with a stub password. 
			User.create!(:email => data["email"], :password => Devise.friendly_token[0,20]) 
		end
	end

end
