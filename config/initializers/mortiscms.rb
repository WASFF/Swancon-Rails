Mortiscms.config do |config|
	config.content_admin_route = {:controller => "admin", :action => "content"}
	config.site_name = "DoomCon 2012"
	config.show_titles_in_pages = true
	config.show_titles_in_tags = true
	config.routes_enabled = true
	config.publish_to_email = {query: MemberDetail.email_list, name: :name_real, email: :email}
	config.publish_from_address = "donotreply@swancon.com.au"
	config.publish_from_friendly_address = "Doom-Con: Swancon 2012 Auto Mailer <donotreply@swancon.com.au>"
	config.link_root = "http://2012.swancon.com.au/"
	config.writer_query_message = :is_writer?
	config.editor_query_message = :is_editor?
	config.user_model = "User"
	config.publish_extra_emails = [["Swancon", "swancon@guild.uwa.edu.au"]]
end