class CreateUserOrderMerchandiseOptions < ActiveRecord::Migration
  def self.up
    create_table :user_order_merchandise_options do |t|
			t.integer :user_order_merchandise_id
			t.integer :merchandise_option_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_order_merchandise_options
  end
end
