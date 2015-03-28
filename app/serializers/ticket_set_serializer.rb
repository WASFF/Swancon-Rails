class TicketSetSerializer < ActiveModel::Serializer
  attributes :id, :name, :requires_extended_details,
    :created_at, :updated_at

  embed :ids, include: true

  has_many :ticket_types

  def include_ticket_types?
    full_tree?
  end

private 
  def full_tree?
    options.has_key?(:full_tree) && options[:full_tree]
  end

end
