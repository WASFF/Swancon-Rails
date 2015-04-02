class TicketTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :concession_price, :price, :description,
    :created_at, :updated_at

  embed :ids, include: true

  has_one :ticket_set, key: :set
end
