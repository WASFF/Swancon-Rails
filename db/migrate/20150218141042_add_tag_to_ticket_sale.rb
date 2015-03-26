class AddTagToTicketSale < ActiveRecord::Migration
  def change
    change_table :user_order_tickets do |t|
      t.integer :advertising_tag_id
    end
  end
end
