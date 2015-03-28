class UserOrderTicketSerializer < ActiveModel::Serializer
  attributes :id, :concession, :redeemed_at, :user_order_id,
    :created_at, :updated_at

  embed :ids, include: true

  has_one :ticket_type, key: :type
end
