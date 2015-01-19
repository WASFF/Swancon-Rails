Mortiscms.config do |config|
	config.content_admin_route = {:controller => "admin", :action => "content"}
	config.site_name = "Swancon 2015"
	config.show_titles_in_pages = true
	config.show_titles_in_tags = true
	config.routes_enabled = true
	config.publish_to_email = {query: MemberDetail.email_list, name: :name, email: :email}
	config.publish_from_address = "donotreply@swancon.com.au"
	config.publish_from_friendly_address = "Swancon 2015 Auto Mailer <donotreply@swancon.com.au>"
	config.authorization_system = :pundit
	config.user_model = "User"
	config.publish_extra_emails = [["Swancon", "swancon@guild.uwa.edu.au"]]
end
