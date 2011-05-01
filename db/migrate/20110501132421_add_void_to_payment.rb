class AddVoidToPayment < ActiveRecord::Migration
  def self.up
		change_table :payments do |t|
			t.integer :voiding_user_id
			t.datetime :voided_at
		end
  end

  def self.down
		change_table :payments do |t|
			t.remove :voiding_user_id
			t.remove :voided_at
		end
  end
end
