class CreateUserOrderTickets < ActiveRecord::Migration
  def self.up
    create_table :user_order_tickets do |t|
			t.integer :user_order_id
			t.integer :ticket_type_id
			t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_order_tickets
  end
end
