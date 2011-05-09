class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.string :name
      t.timestamps
    end

		change_table :vendor_orders do |t|
			t.change :vendor_id, :integer, :null => false		
			t.datetime :closed_at, :null => true
		end
  end

  def self.down
    drop_table :vendors

		change_table :vendor_orders do |t|
			t.change :vendor_id, :integer, :null => true
			t.remove :closed_at
		end
  end
end
