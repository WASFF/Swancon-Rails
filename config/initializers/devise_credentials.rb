Devise.setup do |config|
	if FileTest.exists?("#{Rails.root}/privateconfig/devise_credentials.yml")
		DEVISE_CREDENTIALS = YAML.load_file("#{Rails.root}/privateconfig/devise_credentials.yml")
		DEVISE_CREDENTIALS.keys.each do |authtype|
			config.omniauth authtype.parameterize.underscore.to_sym, DEVISE_CREDENTIALS[authtype]['app_id'], DEVISE_CREDENTIALS[authtype]['app_secret']
		end
	end
end