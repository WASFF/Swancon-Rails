class CreateUserOrders < ActiveRecord::Migration
  def self.up
    create_table :user_orders do |t|
			t.integer :user_id
			t.integer :payment_id
			t.integer :payment_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_orders
  end
end
