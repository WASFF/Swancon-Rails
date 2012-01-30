source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails', '>= 1.0.14'
gem 'sqlite3'
gem 'devise', :git => "https://github.com/plataformatec/devise.git"
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem "oa-oauth", :require => "omniauth/oauth"
gem 'declarative_authorization'
gem 'capistrano'

#gem 'MortisCMS', :require => 'mortiscms', :path => '/Users/lordmortis/Projects/MortisCMS'
gem 'MortisCMS', :require => 'mortiscms', :git => 'git://github.com/lordmortis/MortisCMS.git'

group :production do
	gem 'therubyracer', :platforms => :ruby
end