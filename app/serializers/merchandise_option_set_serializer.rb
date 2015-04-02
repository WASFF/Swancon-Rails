class MerchandiseOptionSetSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at

  embed :ids, include: true
#  has_many :merchandise_sets, key: :merchandise

private 
  def full_tree?
    options.has_key?(:full_tree) && options[:full_tree]
  end
end
