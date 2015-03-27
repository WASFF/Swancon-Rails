class UserSerializer < ActiveModel::Serializer
  delegate :user_can?, to: :scope
  self.root = "member"

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
        name_first: object.member_detail.name_first,
        name_last: object.member_detail.name_last,
        name_badge: object.member_detail.name_badge,
        address_1: object.member_detail.address_1,
        address_2: object.member_detail.address_2,
        address_3: object.member_detail.address_3,
        address_postcode: object.member_detail.address_postcode,
        address_state: object.member_detail.address_country,
        address_country: object.member_detail.address_country,
        phone: object.member_detail.phone,
        email_optin: object.member_detail.email_optin,
        disclaimer_signed: object.member_detail.disclaimer_signed
      })
    end

    if user_can?(:view_extended_details, object) and @options[:include_ticket_details]
      data[:tickets] = []
      object.user_order_tickets.redeemable_convention_ticket.each do |ticket|
        data[:tickets] << {id: ticket.id, name: ticket.type.order_name, redeemed: false}
      end
    end

    data
  end
end
