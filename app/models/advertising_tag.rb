class AdvertisingTag < ActiveRecord::Base
  has_many :user_order_tickets

  def tickets
    user_order_tickets
  end
end
