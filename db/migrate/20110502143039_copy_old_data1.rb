class CopyOldData1 < ActiveRecord::Migration
  def self.up
		badcathy = LaunchMember.find(29).destroy
		badhelen = LaunchMember.find(55)
		badhelen.launch_member_merchandise_types[0].launch_member_id = 52
		badhelen.launch_member_merchandise_types[0].save
		badhelen.destroy
	
		LaunchMember.all.each do |oldmember|			
			user = User.where(:email => oldmember.email).first
			if (user == nil)
				username = oldmember.username
				user = User.where(:username => username).first
				if (user != nil)
					username = "#{username}1"
				end
				user = User.new(:username => username, :password => Devise.friendly_token[0,20])
				if oldmember.email == nil
					user.email = "#{user.username.gsub(" ", "")}@temp.swancon.com.au".downcase
				else
					user.email = oldmember.email.gsub(" ", "").gsub("..", ".").downcase
				end
				user.skip_confirmation!
				user.confirm!
				if !user.save
					print("OMG ERROR - LAUNCH MEMBER #{oldmember.id}\n")
					print("Email: #{user.email}")
				end
			end
			
			member_detail = user.member_detail
			
			if member_detail == nil
				member_detail = MemberDetail.new
			end
			
			member_detail.name_first = oldmember.name_first
			member_detail.name_last = oldmember.name_last
			member_detail.name_badge = oldmember.name_badge
			member_detail.address_1 = oldmember.address_street1
			member_detail.address_2 = oldmember.address_street2
			member_detail.address_3 = oldmember.address_street3
			member_detail.address_postcode = oldmember.address_postcode
			member_detail.address_state = oldmember.address_state
			member_detail.address_country = oldmember.address_country
			member_detail.phone = oldmember.phoneno
			member_detail.email_optin = oldmember.email_optin

			member_detail.save
			user.member_detail = member_detail
			user.save
			
			oldmember.payments.each do |payment|
				order = UserOrder.new(:user => user, :payment => payment, :payment_type => payment.payment_type)
				order.save
				payment.launch_member_ticket_types.each do |lmtt|
					uot = UserOrderTicket.new(:ticket_type => lmtt.ticket_type, :user => user, :user_order => order)
					uot.save
				end
				payment.launch_member_merchandise_types.each do |lmmt|
					umt = UserOrderMerchandise.new(:merchandise_type => lmmt.merchandise_type, :user_order => order)
					umt.save
					lmmt.options.each do |option|
						uomo = UserOrderMerchandiseOption.new(:user_order_merchandise => umt, :merchandise_option_id => option.id)
						uomo.save
					end
				end
			end			
		end	
  end

  def self.down
		raise ActiveRecord::IrreversibleMigration
  end
end
