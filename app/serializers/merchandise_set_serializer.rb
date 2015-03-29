class MerchandiseSetSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at

  embed :ids, include: true
  has_many :merchandise_types, key: :merchandise

  def include_merchandise_types?
    full_tree?
  end

private 
  def full_tree?
    options.has_key?(:full_tree) && options[:full_tree]
  end

end
