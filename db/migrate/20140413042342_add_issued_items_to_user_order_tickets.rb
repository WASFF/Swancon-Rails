class AddIssuedItemsToUserOrderTickets < ActiveRecord::Migration
  def change
  	add_column :user_order_tickets, :redeemed_at, :datetime
  end
end
