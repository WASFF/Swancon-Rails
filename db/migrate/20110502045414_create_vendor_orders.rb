class CreateVendorOrders < ActiveRecord::Migration
  def self.up
    create_table :vendor_orders do |t|
      t.integer :vendor_id
			t.datetime :placed_at
      t.timestamps
    end

		change_table :user_order_merchandises do |t|
			t.integer :vendor_order_id
			t.datetime :arrived_at
			t.datetime :shipped_at
		end
  end

  def self.down
    drop_table :vendor_orders

		change_table :user_order_merchandises do |t|
			t.remove :vendor_order_id
			t.remove :arrived_at
			t.remove :shipped_at
		end
  end
end
