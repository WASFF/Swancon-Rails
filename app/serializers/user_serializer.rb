class UserSerializer < ActiveModel::Serializer
	delegate :user_can?, to: :scope
	self.root = "user"

  attributes :id, :username

  def attributes
    data = super
    delete = []
    if user_can? :view_extended_details?, object
    	[:email, :sign_in_count].each do |key|
    		data[key] = object.send(key)
    	end
    end

    if @options[:include_member_details] and user_can?(:view_extended_details?, object) and object.member_detail.present?
    	data.merge!({
				"member_detail_attributes[name_first]" =>
					object.member_detail.name_first,
				"member_detail_attributes[name_last]" =>
					object.member_detail.name_last,
				"member_detail_attributes[name_badge]" =>
					object.member_detail.name_badge,
				"member_detail_attributes[address_1]" =>
					object.member_detail.address_1,
				"member_detail_attributes[address_2]" =>
					object.member_detail.address_2,
				"member_detail_attributes[address_3]" =>
					object.member_detail.address_3,								
				"member_detail_attributes[address_postcode]" =>
					object.member_detail.address_postcode,
				"member_detail_attributes[address_state]" =>
					object.member_detail.address_state,
				"member_detail_attributes[address_country]" =>
					object.member_detail.address_country,
				"member_detail_attributes[phone]" =>
					object.member_detail.phone,
				"member_detail_attributes[email_optin]" =>
					object.member_detail.email_optin,
				"member_detail_attributes[disclaimer_signed]" =>
					object.member_detail.disclaimer_signed
				})
    end

    if user_can?(:view_extended_details, object) and @options[:include_ticket_details]
    	data[:tickets] = []
    	object.user_order_tickets.paid.each do |ticket|
    		if ticket.requires_extended_details
    			data[:tickets] << {name: ticket.type.order_name, redeemed: false}
    		end
    	end
    end

    data
  end
end
