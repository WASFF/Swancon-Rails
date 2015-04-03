class UserOrderTicketSerializer < ActiveModel::Serializer
  attributes :id, :concession, :user_order_id,
    :paid_at, :redeemed_at, :created_at, :updated_at

  embed :ids, include: true

  has_one :ticket_type, key: :type

  def paid_at
    if object.order.payment.present?
      object.order.payment.created_at
    else
      nil
    end
  end
end
