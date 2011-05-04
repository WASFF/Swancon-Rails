class AddOrderIndexToMerchOptions < ActiveRecord::Migration
  def self.up
		change_table :merchandise_options do |t|
			t.integer :order_index, :default => 0, :null => false
		end
  end

  def self.down
		change_table :merchandise_options do |t|
			t.remove :order_index
		end
  end
end
