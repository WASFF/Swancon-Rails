class MerchandiseOptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :order_index, :created_at, :updated_at

  embed :ids, include: true
  has_one :merchandise_option_set, key: :set
end
