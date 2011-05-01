class CreateUserOrderMerchandises < ActiveRecord::Migration
  def self.up
    create_table :user_order_merchandises do |t|
			t.integer :user_order_id
			t.integer :merchandise_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_order_merchandises
  end
end
