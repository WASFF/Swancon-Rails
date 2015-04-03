class MerchandiseTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :price,
    :created_at, :updated_at

  embed :ids, include: true
  has_one :merchandise_set, key: :set
  has_many :merchandise_option_sets, key: :option_sets
  has_many :merchandise_options, key: :options
end
