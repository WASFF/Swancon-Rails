#if Rails.env == "production" or Rails.env == "staging"
  DoomCon::Application.config.middleware.use ExceptionNotification::Rack,
    :email => {
#      :email_prefix => "[Swancon WebApp - #{DoomCon::Application.config.swancon_year} #{Rails.env}] ",
#      :sender_address => %{"#{DoomCon::Application.config.swancon_year}-#{Rails.env}" <noreply@swancon.com>},
      exception_recipients: %w{lordmortis@sektorseven.net}
    }
#end
