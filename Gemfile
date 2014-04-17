source 'http://rubygems.org'

gem 'rails', '4.0.4'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails', '~> 4.0.2'
gem 'compass-rails'
#TODO: this should not be required when we start using sass rails 4.0.2
gem 'sprockets', '2.11.0'
gem 'coffee-rails'
gem 'uglifier'

# Restores line errors, should only be required until https://github.com/sstephenson/execjs/pull/140 is merged.
gem "execjs", git: "https://github.com/4ormat/execjs.git", ref: "fe2bde333660f4893be59fb7a4fd7f42ae5934ac"

gem 'jquery-rails'
gem 'momentjs-rails'

gem 'sqlite3'
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem "oa-oauth", :require => "omniauth/oauth"
gem "pundit"

gem 'actionmailer-with-request'
gem 'squeel'
gem 'csv_builder'

gem "nested_form"

gem "rails-settings-cached", "0.3.1"

#gem 'MortisCMS', :require => 'mortiscms', :path => '/Users/lordmortis/Projects/MortisCMS'
gem 'MortisCMS', require: 'mortiscms', git: 'git://github.com/lordmortis/MortisCMS.git', branch: :rails4

gem "haml-rails"

gem "exception_notification"

gem "active_model_serializers"

group :development do
	gem 'capistrano-rails'
	gem 'capistrano-rvm'
	gem 'byebug'
	gem 'letter_opener'
end

group :development, :test do

end

